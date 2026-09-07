import 'package:flutter/material.dart';
import '../../../data/catalog.dart';
import '../../../session/app_state.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dims.dart';
import '../../../theme/app_text.dart';
import '../../../widgets/craft_image.dart';
import '../../../widgets/india_map.dart';
import '../../../widgets/ornament.dart';
import '../../../widgets/top_bar.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key, this.onState});
  final void Function(CraftState)? onState;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _query = '';

  List<CraftState> get _results {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return const [];

    return Catalog.states.where((state) {
      final products = Catalog.products.where(
        (product) => product.stateId == state.id,
      );
      final stateText = [
        state.name.en,
        state.name.hi,
        state.crafts.en,
        state.crafts.hi,
        state.heritage.en,
        state.heritage.hi,
        ...products.expand(
          (product) => [
            product.name.en,
            product.name.hi,
            product.artisan.en,
            product.artisan.hi,
            product.material.en,
            product.material.hi,
            product.technique.en,
            product.technique.hi,
          ],
        ),
      ].join(' ').toLowerCase();
      return stateText.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final hi = context.lang.name == 'hi';

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, Gap.sm, 0, Gap.section),
      children: [
        Center(
          child: Text(
            s.exploreTitle,
            style: hi
                ? AppText.hi(27, weight: 700, color: AppColors.ink)
                : AppText.en(28, weight: 600, color: AppColors.ink),
          ),
        ),
        const SizedBox(height: Gap.sm),
        const Center(child: OrnamentDivider()),
        const SizedBox(height: Gap.md),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Gap.xxl),
          child: Text(
            s.exploreSubtitle,
            textAlign: TextAlign.center,
            style: AppText.body(13, color: AppColors.inkMuted),
          ),
        ),
        const SizedBox(height: Gap.xl),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Gap.page),
          child: SearchField(
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        if (_query.trim().isNotEmpty) ...[
          const SizedBox(height: Gap.md),
          _SearchResults(results: _results, onState: widget.onState),
        ],
        const SizedBox(height: Gap.xxl),

        _MapBlock(onState: widget.onState),
        const SizedBox(height: Gap.xxl),

        _SectionLabel(s.browseByCraft),
        const SizedBox(height: Gap.md),
        const _CategoryGrid(),
        const SizedBox(height: Gap.xxl),

        _SectionLabel(s.allStates),
        const SizedBox(height: Gap.md),
        _StateList(onState: widget.onState),
        const SizedBox(height: Gap.xl),
        const _SupportBanner(),
      ],
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.results, this.onState});
  final List<CraftState> results;
  final void Function(CraftState)? onState;

  @override
  Widget build(BuildContext context) {
    final lang = context.lang;
    final s = context.s;

    if (results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Gap.page),
        child: Text(s.allStates, style: AppText.caption),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Gap.page),
          child: Text(
            s.allStates,
            style: lang.name == 'hi'
                ? AppText.sectionTitleHi
                : AppText.sectionTitleEn,
          ),
        ),
        const SizedBox(height: Gap.sm),
        for (final state in results)
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.page, 0, Gap.page, Gap.sm),
            child: _SearchResultCard(state: state, onState: onState),
          ),
      ],
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({required this.state, this.onState});
  final CraftState state;
  final void Function(CraftState)? onState;

  @override
  Widget build(BuildContext context) {
    final lang = context.lang;
    final s = context.s;
    final products = Catalog.products
        .where((product) => product.stateId == state.id)
        .toList();

    return GestureDetector(
      onTap: () => onState?.call(state),
      child: Container(
        padding: const EdgeInsets.all(Gap.md),
        decoration: BoxDecoration(
          color: AppColors.creamAlt,
          borderRadius: Radii.md,
          border: Border.all(
            color: AppColors.terracotta.withValues(alpha: .35),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: CraftImage(
                    seed: state.seed,
                    icon: Icons.landscape_outlined,
                    borderRadius: Radii.sm,
                  ),
                ),
                const SizedBox(width: Gap.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.name.call(lang),
                        style: AppText.body(
                          16,
                          weight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(state.crafts.call(lang), style: AppText.caption),
                    ],
                  ),
                ),
                Text('${state.count} ${s.craftsCount}', style: AppText.caption),
              ],
            ),
            const SizedBox(height: Gap.md),
            Text(
              state.heritage.call(lang),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppText.body(
                12.5,
                color: AppColors.inkMuted,
                height: 1.35,
              ),
            ),
            if (products.isNotEmpty) ...[
              const SizedBox(height: Gap.sm),
              Text(s.craftsFrom, style: AppText.caption),
              const SizedBox(height: 3),
              Wrap(
                spacing: Gap.sm,
                runSpacing: 3,
                children: [
                  for (final product in products.take(3))
                    Text(product.name.call(lang), style: AppText.link),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Tappable map of India. States we stock are filled; the rest are muted so
/// the eye lands where there is something to buy.
class _MapBlock extends StatelessWidget {
  const _MapBlock({this.onState});
  final void Function(CraftState)? onState;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Gap.page),
      child: Column(
        children: [
          IndiaMap(
            activeIds: craftStateIds,
            onState: (id) {
              final match = Catalog.states
                  .where((st) => st.id == id)
                  .firstOrNull;
              if (match != null) onState?.call(match);
            },
          ),
          const SizedBox(height: Gap.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.touch_app_outlined,
                size: 15,
                color: AppColors.inkFaint,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  s.tapAState,
                  style: AppText.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Gap.page),
      child: Text(
        text,
        style: context.lang.name == 'hi'
            ? AppText.sectionTitleHi
            : AppText.sectionTitleEn,
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid();

  @override
  Widget build(BuildContext context) {
    final lang = context.lang;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Gap.page),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: Catalog.categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: Gap.md,
          crossAxisSpacing: Gap.md,
          childAspectRatio: 0.82,
        ),
        itemBuilder: (context, i) {
          final c = Catalog.categories[i];
          return Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: Radii.md,
                  border: Border.all(color: AppColors.line),
                ),
                child: Icon(c.icon, size: 22, color: AppColors.terracotta),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  c.name(lang),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: AppText.body(11, height: 1.25),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StateList extends StatelessWidget {
  const _StateList({this.onState});
  final void Function(CraftState)? onState;

  @override
  Widget build(BuildContext context) {
    final lang = context.lang;
    final s = context.s;

    return Column(
      children: [
        for (final st in Catalog.states)
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.page, 0, Gap.page, Gap.sm),
            child: GestureDetector(
              onTap: () => onState?.call(st),
              child: Container(
                padding: const EdgeInsets.all(Gap.sm),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: Radii.md,
                  border: Border.all(color: AppColors.line),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 46,
                      height: 46,
                      child: CraftImage(
                        seed: st.seed,
                        icon: Icons.landscape_outlined,
                        borderRadius: Radii.sm,
                      ),
                    ),
                    const SizedBox(width: Gap.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            st.name(lang),
                            style: AppText.body(
                              14.5,
                              weight: FontWeight.w600,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(st.crafts(lang), style: AppText.caption),
                        ],
                      ),
                    ),
                    Text(
                      '${st.count} ${s.craftsCount}',
                      style: AppText.body(11.5, color: AppColors.inkFaint),
                    ),
                    const SizedBox(width: Gap.sm),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: AppColors.inkFaint,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SupportBanner extends StatelessWidget {
  const _SupportBanner();

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Gap.page),
      child: Container(
        padding: const EdgeInsets.all(Gap.lg),
        decoration: BoxDecoration(
          color: AppColors.creamAlt,
          borderRadius: Radii.md,
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.volunteer_activism_outlined,
              size: 26,
              color: AppColors.terracotta,
            ),
            const SizedBox(width: Gap.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.supportTitle,
                    style: AppText.body(
                      14,
                      weight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(s.supportBody, style: AppText.caption),
                  const SizedBox(height: Gap.sm),
                  Row(
                    children: [
                      Text(s.learnMore, style: AppText.link),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 17,
                        color: AppColors.terracotta,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
