import 'package:flutter/material.dart';
import '../session/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_dims.dart';
import '../theme/app_text.dart';
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
            onPressed: onMenu,
            icon: const Icon(Icons.menu_rounded),
            color: AppColors.ink,
          ),
          Expanded(
            child: Center(
              child: Wordmark(
                script: app.lang.name == 'hi' ? Script.devanagari : Script.latin,
                size: 25,
                showTagline: showTagline,
              ),
            ),
          ),
          IconButton(
            onPressed: onSearch,
            icon: const Icon(Icons.search_rounded),
            color: AppColors.ink,
          ),
          _CartButton(count: app.cartCount, onTap: onCart),
          const SizedBox(width: Gap.xs),
        ],
      ),
    );
  }
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
                style: AppText.body(10.5,
                    weight: FontWeight.w700, color: AppColors.white, height: 1.25),
              ),
            ),
          ),
      ],
    );
  }
}

/// The search field used on Explore, and behind the header search icon.
class SearchField extends StatelessWidget {
  const SearchField({super.key, this.onTap, this.autofocus = false});
  final VoidCallback? onTap;
  final bool autofocus;

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
              autofocus: autofocus,
              onTap: onTap,
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
            onPressed: () {},
            icon: const Icon(Icons.mic_none_rounded, size: 20),
            color: AppColors.terracotta,
          ),
        ],
      ),
    );
  }
}
