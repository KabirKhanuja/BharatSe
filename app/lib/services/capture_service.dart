import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// Camera, gallery and microphone.
///
/// One object owns the audio session. `record` and any speech recogniser
/// cannot both hold the microphone on Android, so everything that touches it
/// goes through here.
class CaptureService {
  final ImagePicker _picker = ImagePicker();
  final AudioRecorder _recorder = AudioRecorder();

  bool _recording = false;
  bool get isRecording => _recording;

  // ------------------------------------------------------------------ photos
  /// Downscaled before it ever leaves the phone. We are not pushing a twelve
  /// megapixel file over village 4G, and 1600px is more than any marketplace
  /// needs.
  Future<String?> takePhoto() async {
    final file = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1600,
      imageQuality: 82,
    );
    return file?.path;
  }

  Future<String?> pickFromGallery() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 82,
    );
    return file?.path;
  }

  // ------------------------------------------------------------------- audio
  Future<bool> hasMicPermission() => _recorder.hasPermission();

  /// 16 kHz mono WAV, which is exactly what the API and every provider behind
  /// it expects. That is why this app has no audio conversion step and does
  /// not depend on ffmpeg, which is retired and no longer builds anyway.
  Future<bool> startRecording() async {
    if (_recording) return true;
    if (!await _recorder.hasPermission()) return false;

    final directory = await getTemporaryDirectory();
    final path =
        '${directory.path}/note_${DateTime.now().millisecondsSinceEpoch}.wav';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        numChannels: 1,
      ),
      path: path,
    );

    _recording = true;
    return true;
  }

  /// Returns the file path, or null if the note was too short to be speech.
  Future<String?> stopRecording({Duration minimum = const Duration(milliseconds: 700)}) async {
    if (!_recording) return null;

    final path = await _recorder.stop();
    _recording = false;
    if (path == null) return null;

    final file = File(path);
    if (!await file.exists()) return null;

    // A 16 kHz mono 16 bit WAV is 32,000 bytes per second. Anything under the
    // minimum is a mis-tap, not a voice note, and sending it wastes a call and
    // returns nonsense.
    final minimumBytes = 32000 * minimum.inMilliseconds ~/ 1000;
    if (await file.length() < minimumBytes) {
      await file.delete();
      return null;
    }

    return path;
  }

  Future<void> cancelRecording() async {
    if (!_recording) return;
    await _recorder.cancel();
    _recording = false;
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }
}
