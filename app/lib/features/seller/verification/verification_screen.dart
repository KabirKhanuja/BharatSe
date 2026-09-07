import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../../data/remote/api_client.dart';
import '../../../data/remote/api_models.dart';
import '../../../session/app_state.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dims.dart';
import '../../../theme/app_text.dart';
import '../../../widgets/wordmark.dart';

/// Identity review, the gate between signing in and listing anything.
///
/// Three states rather than a form with a flag: she has not sent a document,
/// she has sent one and is waiting, or she is approved. Each one is a different
/// screen because each one has a different single next action, and for the
/// middle one that action is to close the app and come back.
class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, required this.onApproved});
  final VoidCallback onApproved;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String? _documentPath;
  bool _sending = false;
  bool _checking = false;
  String? _error;

  VerificationState get _state => context.app.verification.state;

  Future<void> _pickDocument({required bool fromCamera}) async {
    final capture = context.app.capture;
    final path = fromCamera
        ? await capture.takePhoto()
        : await capture.pickFromGallery();
    if (path != null && mounted) setState(() => _documentPath = path);
  }

  Future<void> _submit() async {
    final path = _documentPath;
    if (path == null || _sending) return;

    final app = context.app;
    setState(() {
      _sending = true;
      _error = null;
    });

    try {
      await app.ensureSession();
      await app.api.submitVerification(documentPath: path);
      await app.refreshVerification();
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _error =
          error.isOffline ? context.s.offlineNotice : '${context.s.verifyFailed}. ${error.message}');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _recheck() async {
    setState(() => _checking = true);
    await context.app.refreshVerification();
    if (!mounted) return;
    setState(() => _checking = false);
    if (context.app.verification.state.canSell) widget.onApproved();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(Gap.page, Gap.md, Gap.page, Gap.lg),
              child: Wordmark(size: 24, showTagline: true),
            ),
            Expanded(
              child: switch (_state) {
                VerificationState.pending => _pending(),
                VerificationState.approved => _approved(),
                VerificationState.notSubmitted => _form(),
              },
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------- form
  Widget _form() {
    final s = context.s;

    return ListView(
      padding: const EdgeInsets.fromLTRB(Gap.page, 0, Gap.page, Gap.section),
      children: [
        Text(s.verifyTitle,
            style: context.lang.name == 'hi'
                ? AppText.hi(24, weight: 700, color: AppColors.ink)
                : AppText.en(26, weight: 600, color: AppColors.ink)),
        const SizedBox(height: Gap.sm),
        Text(s.verifySubtitle, style: AppText.body(14, color: AppColors.inkMuted)),
        const SizedBox(height: Gap.xl),

        Container(
          padding: const EdgeInsets.all(Gap.lg),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: Radii.md,
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.badge_outlined, size: 20, color: AppColors.terracotta),
              const SizedBox(width: Gap.md),
              Expanded(
                child: Text(s.verifyWhy,
                    style: AppText.body(13, color: AppColors.inkMuted, height: 1.55)),
              ),
            ],
          ),
        ),
        const SizedBox(height: Gap.xl),

        _documentTile(),
        const SizedBox(height: Gap.md),

        Row(
          children: [
            const Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.inkFaint),
            const SizedBox(width: 6),
            Expanded(child: Text(s.verifyPrivacy, style: AppText.caption)),
          ],
        ),

        if (_error != null) ...[
          const SizedBox(height: Gap.lg),
          _errorNote(_error!),
        ],

        const SizedBox(height: Gap.xl),
        SizedBox(
          height: 54,
          child: FilledButton(
            onPressed: _documentPath == null || _sending ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.maroon,
              disabledBackgroundColor: AppColors.line,
            ),
            child: Text(_sending ? s.verifySubmitting : s.verifySubmit,
                style: AppText.body(16,
                    weight: FontWeight.w600, color: AppColors.white)),
          ),
        ),
      ],
    );
  }

  Widget _documentTile() {
    final s = context.s;
    final path = _documentPath;

    if (path == null) {
      return InkWell(
        key: const Key('pick-document'),
        onTap: _showPicker,
        borderRadius: Radii.md,
        child: Container(
          height: 168,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: Radii.md,
            border: Border.all(
              color: AppColors.terracotta.withValues(alpha: 0.4),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_a_photo_outlined,
                  size: 30, color: AppColors.terracotta),
              const SizedBox(height: Gap.md),
              Text(s.verifyUpload,
                  style: AppText.body(15,
                      weight: FontWeight.w600, color: AppColors.terracotta)),
              const SizedBox(height: 4),
              Text(s.verifyDocumentHint, style: AppText.caption),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: Radii.md,
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: kIsWeb
                ? const ColoredBox(color: AppColors.creamAlt)
                : Image.file(File(path), fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: Gap.sm),
        TextButton.icon(
          onPressed: _showPicker,
          icon: const Icon(Icons.refresh_rounded, size: 17),
          label: Text(s.verifyRetake,
              style: AppText.body(13.5,
                  weight: FontWeight.w600, color: AppColors.terracotta)),
        ),
      ],
    );
  }

  Future<void> _showPicker() async {
    final fromCamera = await showModalBottomSheet<bool>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(context.s.addPhoto, style: AppText.body(15)),
              onTap: () => Navigator.of(sheetContext).pop(true),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(context.s.verifyRetake, style: AppText.body(15)),
              onTap: () => Navigator.of(sheetContext).pop(false),
            ),
          ],
        ),
      ),
    );
    if (fromCamera != null) await _pickDocument(fromCamera: fromCamera);
  }

  // ----------------------------------------------------------------- pending
  Widget _pending() {
    final s = context.s;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Gap.section),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.creamAlt,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
              ),
              child: const Icon(Icons.hourglass_bottom_rounded,
                  size: 32, color: AppColors.gold),
            ),
            const SizedBox(height: Gap.xl),
            Text(s.verifyPendingTitle,
                style: AppText.body(18, weight: FontWeight.w600)),
            const SizedBox(height: Gap.sm),
            Text(s.verifyPendingBody,
                textAlign: TextAlign.center,
                style: AppText.body(13.5, color: AppColors.inkMuted, height: 1.55)),
            const SizedBox(height: Gap.xl),
            OutlinedButton.icon(
              onPressed: _checking ? null : _recheck,
              icon: _checking
                  ? const SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(strokeWidth: 1.8))
                  : const Icon(Icons.refresh_rounded, size: 17),
              label: Text(s.checkAgain,
                  style: AppText.body(14, weight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _approved() {
    final s = context.s;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_rounded, size: 52, color: AppColors.success),
          const SizedBox(height: Gap.lg),
          Text(s.verifyApprovedTitle,
              style: AppText.body(18, weight: FontWeight.w600)),
          const SizedBox(height: Gap.xl),
          FilledButton(
            onPressed: widget.onApproved,
            child: Text(s.addProduct,
                style: AppText.body(15,
                    weight: FontWeight.w600, color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  Widget _errorNote(String message) {
    return Container(
      padding: const EdgeInsets.all(Gap.md),
      decoration: BoxDecoration(
        color: const Color(0xFFF7EFEF),
        borderRadius: Radii.sm,
        border: Border.all(color: AppColors.maroon.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.maroon),
          const SizedBox(width: Gap.sm),
          Expanded(
            child: Text(message,
                style: AppText.body(12.5, color: AppColors.maroon, height: 1.35)),
          ),
        ],
      ),
    );
  }
}
