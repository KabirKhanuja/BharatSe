import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_dims.dart';
import 'app_text.dart';

abstract final class AppTheme {
  static const systemOverlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  /// Material 3, with the palette stated explicitly rather than generated from
  /// a seed. A seeded scheme would harmonise our terracotta and gold towards
  /// each other and lose the warmth the brand depends on.
  static const _scheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.navy,
    onPrimary: AppColors.white,
    primaryContainer: Color(0xFFDCE4EC),
    onPrimaryContainer: AppColors.navyDeep,
    secondary: AppColors.terracotta,
    onSecondary: AppColors.white,
    secondaryContainer: Color(0xFFF4E2D8),
    onSecondaryContainer: Color(0xFF5C2612),
    tertiary: AppColors.gold,
    onTertiary: AppColors.white,
    tertiaryContainer: Color(0xFFF6EBD2),
    onTertiaryContainer: Color(0xFF5A4715),
    error: AppColors.maroon,
    onError: AppColors.white,
    errorContainer: Color(0xFFF7DEDE),
    onErrorContainer: Color(0xFF5A0F13),
    surface: AppColors.cream,
    onSurface: AppColors.ink,
    surfaceContainerLowest: AppColors.white,
    surfaceContainerLow: AppColors.cream,
    surfaceContainer: AppColors.creamAlt,
    surfaceContainerHigh: Color(0xFFEDE6DB),
    surfaceContainerHighest: Color(0xFFE7E0D5),
    onSurfaceVariant: AppColors.inkMuted,
    outline: AppColors.line,
    outlineVariant: Color(0xFFF0EAE0),
    inverseSurface: AppColors.ink,
    onInverseSurface: AppColors.cream,
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );

  static ThemeData get light {
    final base = ThemeData(useMaterial3: true, colorScheme: _scheme);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.cream,
      splashFactory: InkSparkle.splashFactory,
      textTheme: base.textTheme.apply(fontFamily: 'Mukta'),
      dividerTheme: const DividerThemeData(
        color: AppColors.line,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppText.body(18, weight: FontWeight.w600),
        systemOverlayStyle: systemOverlay,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.white,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: Radii.md,
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: _scheme.secondaryContainer,
        indicatorShape:
            const RoundedRectangleBorder(borderRadius: Radii.pill),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return AppText.body(
            11.5,
            weight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? AppColors.navy : AppColors.inkFaint,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color: selected ? AppColors.navy : AppColors.inkFaint,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: AppColors.white,
          textStyle: AppText.button,
          minimumSize: const Size(0, 52),
          shape: const RoundedRectangleBorder(borderRadius: Radii.md),
          padding: const EdgeInsets.symmetric(horizontal: Gap.xl),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          side: const BorderSide(color: AppColors.navy),
          minimumSize: const Size(0, 52),
          shape: const RoundedRectangleBorder(borderRadius: Radii.md),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.white,
        side: const BorderSide(color: AppColors.line),
        labelStyle: AppText.body(12.5, weight: FontWeight.w500),
        shape: const RoundedRectangleBorder(borderRadius: Radii.pill),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        hintStyle: AppText.body(14, color: AppColors.inkFaint),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: Gap.lg, vertical: Gap.md),
        border: OutlineInputBorder(
          borderRadius: Radii.md,
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: Radii.md,
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Radii.md,
          borderSide: const BorderSide(color: AppColors.terracotta, width: 1.4),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.terracotta,
        contentPadding: EdgeInsets.symmetric(horizontal: Gap.lg),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        contentTextStyle: AppText.body(13.5, color: AppColors.cream),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: Radii.sm),
      ),
      iconTheme: const IconThemeData(color: AppColors.ink, size: 22),
    );
  }
}
