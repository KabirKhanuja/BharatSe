import 'package:flutter/material.dart';

import '../l10n/lang.dart';
import '../session/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_dims.dart';
import '../theme/app_text.dart';

/// The language picker, in one place so the header menu and the profile screen
/// cannot drift apart.
///
/// Every entry leads with the language's own name rather than its English one,
/// because someone looking for Marathi is looking for मराठी.
Future<void> showLanguageSheet(BuildContext context) async {
  final app = context.app;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.72,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Gap.page, Gap.md, Gap.page, Gap.sm),
              child: Text(app.s.chooseLanguage, style: AppText.sectionTitleEn),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final lang in Lang.values)
                    ListTile(
                      title: Text(
                        lang.nativeName,
                        style: AppText.body(16, weight: FontWeight.w600),
                      ),
                      subtitle: lang.nativeName == lang.englishName
                          ? null
                          : Text(lang.englishName, style: AppText.caption),
                      trailing: app.lang == lang
                          ? const Icon(Icons.check_circle_rounded,
                              color: AppColors.terracotta, size: 21)
                          : null,
                      onTap: () {
                        app.setLang(lang);
                        Navigator.of(sheetContext).pop();
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: Gap.sm),
          ],
        ),
      ),
    ),
  );
}
