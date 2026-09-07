import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../session/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_dims.dart';
import '../theme/app_text.dart';
import 'language_sheet.dart';
import 'wordmark.dart';

/// Shared buyer header: menu, wordmark, search and cart.
class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    this.showTagline = true,
    this.onMenu,
    this.onSearch,
    this.onCart,
  });

  final bool showTagline;
  final VoidCallback? onMenu;
  final VoidCallback? onSearch;
  final VoidCallback? onCart;

  @override
  Widget build(BuildContext context) {
    final app = context.app;

    return Padding(
      padding: const EdgeInsets.fromLTRB(Gap.sm, Gap.sm, Gap.sm, Gap.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onMenu ?? () => _showAccountSheet(context),
            icon: const Icon(Icons.menu_rounded),
            color: AppColors.ink,
          ),
          Expanded(
            child: Center(
              child: Wordmark(
                script: app.lang.name == 'hi'
                    ? Script.devanagari
                    : Script.latin,
                size: 25,
                showTagline: showTagline,
              ),
            ),
          ),
          _CartButton(count: app.cartCount, onTap: onCart),
          const SizedBox(width: Gap.xs),
        ],
      ),
    );
  }
}

/// What the menu opens. Small on purpose: the only thing a buyer actually
/// needs from here today is a way out, and offering a drawer full of dead
/// entries is worse than offering one that works.
Future<void> _showAccountSheet(BuildContext context) async {
  final app = context.app;
  final s = context.s;

  await showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline_rounded),
            title: Text(app.signedIn ? (app.name ?? s.guestName) : s.guestName,
                style: AppText.body(15, weight: FontWeight.w600)),
            subtitle: Text(
              app.role == Role.seller ? s.continueAsSeller : s.continueAsBuyer,
              style: AppText.caption,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.translate_rounded),
            title: Text(s.language, style: AppText.body(15)),
            trailing: Text(app.lang.nativeName, style: AppText.caption),
            onTap: () {
              Navigator.of(sheetContext).pop();
              showLanguageSheet(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.maroon),
            title: Text(s.signOut,
                style: AppText.body(15,
                    weight: FontWeight.w600, color: AppColors.maroon)),
            onTap: () {
              Navigator.of(sheetContext).pop();
              app.signOutEverywhere();
            },
          ),
          const SizedBox(height: Gap.sm),
        ],
      ),
    ),
  );
}

class _CartButton extends StatelessWidget {
  const _CartButton({required this.count, this.onTap});
  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          key: const Key('cart-button'),
          onPressed: onTap,
          icon: const Icon(Icons.shopping_bag_outlined),
          color: AppColors.ink,
        ),
        if (count > 0)
          Positioned(
            right: 4,
            top: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              constraints: const BoxConstraints(minWidth: 17),
              decoration: BoxDecoration(
                color: AppColors.terracotta,
                borderRadius: Radii.pill,
                border: Border.all(color: AppColors.cream, width: 1.5),
              ),
              child: Text(
                '$count',
                textAlign: TextAlign.center,
                style: AppText.body(
                  10.5,
                  weight: FontWeight.w700,
                  color: AppColors.white,
                  height: 1.25,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// The search field used on Explore, and behind the header search icon.
class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    this.onTap,
    this.onChanged,
    this.autofocus = false,
  });
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _controller = TextEditingController();
  final _speech = SpeechToText();
  bool _isListening = false;

  @override
  void dispose() {
    _controller.dispose();
    _speech.stop();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speech.stop();
      if (mounted) setState(() => _isListening = false);
      return;
    }

    final available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (mounted) setState(() => _isListening = false);
        }
      },
      onError: (_) {
        if (mounted) setState(() => _isListening = false);
      },
    );
    if (!available || !mounted) return;

    setState(() => _isListening = true);
    await _speech.listen(
      onResult: (result) {
        final text = result.recognizedWords;
        _controller.value = _controller.value.copyWith(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
          composing: TextRange.empty,
        );
        widget.onChanged?.call(text);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: Radii.md,
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          const SizedBox(width: Gap.md),
          const Icon(Icons.search_rounded, size: 20, color: AppColors.inkFaint),
          const SizedBox(width: Gap.sm),
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: widget.autofocus,
              onTap: widget.onTap,
              onChanged: widget.onChanged,
              style: AppText.body(14),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: context.s.searchHint,
                hintStyle: AppText.body(14, color: AppColors.inkFaint),
              ),
            ),
          ),
          // Voice search. The artisan-facing app is voice first; the buyer
          // side gets the same affordance because many buyers are regional
          // language speakers too.
          IconButton(
            onPressed: _toggleListening,
            tooltip: _isListening ? 'Stop voice search' : 'Search by voice',
            icon: Icon(
              _isListening ? Icons.stop_rounded : Icons.mic_none_rounded,
              size: 20,
            ),
            color: _isListening ? AppColors.maroon : AppColors.terracotta,
          ),
        ],
      ),
    );
  }
}
