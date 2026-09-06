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

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.navy,
        onPrimary: AppColors.white,
        secondary: AppColors.terracotta,
        onSecondary: AppColors.white,
        surface: AppColors.white,
        onSurface: AppColors.ink,
        error: AppColors.maroon,
      ),
      splashFactory: InkSparkle.splashFactory,
      dividerTheme: const DividerThemeData(
        color: AppColors.line,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: systemOverlay,
      ),
      textTheme: base.textTheme.apply(fontFamily: 'Mukta'),
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
      iconTheme: const IconThemeData(color: AppColors.ink, size: 22),
    );
  }
}
