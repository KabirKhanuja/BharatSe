import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/remote/api_client.dart';
import '../../services/auth_service.dart';
import '../../session/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dims.dart';
import '../../theme/app_text.dart';
import 'video_backdrop.dart';

/// Sign in or sign up, for whichever side of the market they picked.
///
/// The role travels with the request but the server only applies it when the
/// account is created. Someone who signed up to buy cannot become a seller by
/// coming back through the other door, because that would be a way around
/// identity verification.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.wants});
  final Role wants;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();

  bool _creating = false;
  bool _busy = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _run(Future<String> Function() getToken) async {
    if (_busy) return;
    final app = context.app;

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final idToken = await getToken();
      await app.completeSignIn(
        idToken: idToken,
        wants: widget.wants,
        name: _name.text.trim(),
      );
      // The root listens to AppState and swaps the shell, so there is nothing
      // to push here. Just get out of the way.
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } on AuthCancelled {
      debugPrint('[auth] cancelled by user');
    } on ApiException catch (error) {
      debugPrint('[auth] api rejected: ${error.statusCode} ${error.message} '
          'offline=${error.isOffline}');
      if (mounted) {
        setState(() => _error =
            error.isOffline ? context.s.offlineNotice : error.message);
      }
    } catch (error, stack) {
      debugPrint('[auth] failed: $error');
      debugPrint('$stack');
      if (mounted) setState(() => _error = AuthService.messageFor(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _submitEmail() {
    final email = _email.text.trim();
    final password = _password.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = context.s.emailRequired);
      return;
    }
    if (_creating && password.length < 6) {
      setState(() => _error = context.s.passwordTooShort);
      return;
    }

    final auth = context.app.auth;
    _run(() => _creating
        ? auth.signUpWithEmail(email, password, name: _name.text.trim())
        : auth.signInWithEmail(email, password));
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;

    return Scaffold(
      backgroundColor: AppColors.ink,
      body: VideoBackdrop(
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: AppColors.white,
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(Gap.xl, Gap.md, Gap.xl, Gap.xxl),
                  children: [
                    Text(
                      _creating ? s.signUpTitle : s.signInTitle,
                      style: AppText.en(30, weight: 600, color: AppColors.white),
                    ),
                    const SizedBox(height: Gap.sm),
                    Text(
                      widget.wants == Role.seller ? s.sellerBlurb : s.buyerBlurb,
                      style: AppText.body(13.5,
                          color: AppColors.cream.withValues(alpha: 0.8)),
                    ),
                    const SizedBox(height: Gap.section),

                    _GoogleButton(
                      label: s.continueWithGoogle,
                      busy: _busy,
                      onTap: () => _run(context.app.auth.signInWithGoogle),
                    ),
                    const SizedBox(height: Gap.xl),
                    _Divider(label: s.orDivider),
                    const SizedBox(height: Gap.xl),

                    if (_creating) ...[
                      _Field(controller: _name, label: s.nameLabel),
                      const SizedBox(height: Gap.md),
                    ],
                    _Field(
                      controller: _email,
                      label: s.emailLabel,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: Gap.md),
                    _Field(
                      controller: _password,
                      label: s.passwordLabel,
                      obscure: _obscure,
                      trailing: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 19,
                          color: AppColors.cream.withValues(alpha: 0.7),
                        ),
                      ),
                    ),

                    if (_error != null && _error!.isNotEmpty) ...[
                      const SizedBox(height: Gap.md),
                      Text(_error!,
                          style: AppText.body(13, color: const Color(0xFFE9A9AC))),
                    ],

                    const SizedBox(height: Gap.xl),
                    SizedBox(
                      height: 54,
                      child: FilledButton(
                        onPressed: _busy ? null : _submitEmail,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.maroon,
                          disabledBackgroundColor:
                              AppColors.maroon.withValues(alpha: 0.5),
                        ),
                        child: Text(
                          _busy
                              ? s.signingIn
                              : (_creating ? s.createAccount : s.signInAction),
                          style: AppText.body(16,
                              weight: FontWeight.w600, color: AppColors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: Gap.lg),
                    Center(
                      child: TextButton(
                        onPressed: _busy
                            ? null
                            : () => setState(() {
                                  _creating = !_creating;
                                  _error = null;
                                }),
                        child: Text(
                          _creating ? s.haveAccount : s.noAccount,
                          style: AppText.body(13.5,
                              weight: FontWeight.w600, color: AppColors.cream),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    this.obscure = false,
    this.keyboardType,
    this.trailing,
  });

  final TextEditingController controller;
  final String label;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      autocorrect: false,
      style: AppText.body(15, color: AppColors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppText.body(14, color: AppColors.cream.withValues(alpha: 0.75)),
        filled: true,
        fillColor: AppColors.white.withValues(alpha: 0.10),
        suffixIcon: trailing,
        enabledBorder: OutlineInputBorder(
          borderRadius: Radii.md,
          borderSide: BorderSide(color: AppColors.white.withValues(alpha: 0.28)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: Radii.md,
          borderSide: BorderSide(color: AppColors.gold, width: 1.4),
        ),
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({required this.label, required this.busy, required this.onTap});
  final String label;
  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: FilledButton(
        onPressed: busy ? null : onTap,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.white.withValues(alpha: 0.6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Drawn rather than shipped as an asset, so there is no image to
            // fail to load on a cold start.
            const _GoogleMark(),
            const SizedBox(width: Gap.md),
            Text(label,
                style: AppText.body(15.5,
                    weight: FontWeight.w600, color: AppColors.ink)),
          ],
        ),
      ),
    );
  }
}

class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
        'assets/svg/google.svg',
        width: 20,
        height: 20,
      );
}

class _Divider extends StatelessWidget {
  const _Divider({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Container(height: 1, color: AppColors.white.withValues(alpha: 0.25)),
    );

    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Gap.md),
          child: Text(label,
              style: AppText.body(12.5,
                  color: AppColors.cream.withValues(alpha: 0.7))),
        ),
        line,
      ],
    );
  }
}
