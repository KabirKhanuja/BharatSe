import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../theme/app_colors.dart';

/// The looping film behind the landing and sign in screens.
///
/// One controller shared by both, created here and kept alive across the
/// navigation between them, because tearing it down and rebuilding it makes the
/// video restart and flash black exactly when the user taps.
///
/// Everything about it degrades: if the file is missing, if decoding fails, or
/// if the platform has no video support, the screen falls back to a still
/// gradient in the brand colours and nothing above it has to care.
class VideoBackdrop extends StatefulWidget {
  const VideoBackdrop({super.key, required this.child});
  final Widget child;

  @override
  State<VideoBackdrop> createState() => _VideoBackdropState();
}

class _VideoBackdropState extends State<VideoBackdrop> {
  VideoPlayerController? _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final controller =
        VideoPlayerController.asset('assets/video/landing-screen.mp4');
    try {
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(0);
      await controller.play();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _ready = true;
      });
    } catch (_) {
      await controller.dispose();
      if (mounted) setState(() => _ready = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (_ready && controller != null)
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          )
        else
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2A1B12), Color(0xFF6B3A22), Color(0xFF2A1B12)],
              ),
            ),
          ),

        // Scrim. Text over uncontrolled footage is unreadable without one, and
        // this film has bright frames.
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.45, 1.0],
              colors: [
                AppColors.ink.withValues(alpha: 0.45),
                AppColors.ink.withValues(alpha: 0.55),
                AppColors.ink.withValues(alpha: 0.86),
              ],
            ),
          ),
        ),

        widget.child,
      ],
    );
  }
}
