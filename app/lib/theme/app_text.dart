import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography for BharatSe.
///
/// Three families, chosen so that no string in either script can ever fall
/// back to a system font and render as tofu boxes:
///   Playfair      Latin display. Variable weight axis.
///   NotoSerifDev  Devanagari display. Variable weight axis.
///   Mukta         Body text. Covers BOTH Devanagari and Latin with real
///                 static weights, so mixed-script paragraphs stay consistent.
///
/// Use [hi] for Devanagari headings and [en] for Latin headings. Body text
/// uses [body] regardless of script.
abstract final class AppText {
  static List<FontVariation> _w(double weight) => [FontVariation('wght', weight)];

  // ---------------------------------------------------------------- display
  /// Latin display serif. The wordmark, English section headings.
  static TextStyle en(
    double size, {
    double weight = 600,
    Color color = AppColors.navy,
    double height = 1.15,
    double? letterSpacing,
  }) =>
      TextStyle(
        fontFamily: 'Playfair',
        fontVariations: _w(weight),
        fontSize: size,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Devanagari display serif. Hindi headlines.
  static TextStyle hi(
    double size, {
    double weight = 600,
    Color color = AppColors.navy,
    double height = 1.35,
    double? letterSpacing,
  }) =>
      TextStyle(
        fontFamily: 'NotoSerifDev',
        fontVariations: _w(weight),
        fontSize: size,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );

  // ------------------------------------------------------------------- body
  /// Body text. Safe for Devanagari and Latin in the same string.
  static TextStyle body(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
    double height = 1.45,
    double? letterSpacing,
  }) =>
      TextStyle(
        fontFamily: 'Mukta',
        fontWeight: weight,
        fontSize: size,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );

  // ------------------------------------------------------- named role styles
  static TextStyle get sectionTitleHi => hi(19, weight: 600, color: AppColors.ink);
  static TextStyle get sectionTitleEn => en(20, weight: 600, color: AppColors.ink);

  /// Small all-caps region label above a product name. Terracotta.
  static TextStyle get eyebrow => body(
        11.5,
        weight: FontWeight.w600,
        color: AppColors.terracotta,
        letterSpacing: 0.4,
      );

  static TextStyle get productName =>
      body(15, weight: FontWeight.w600, color: AppColors.ink, height: 1.3);

  static TextStyle get price =>
      body(15.5, weight: FontWeight.w700, color: AppColors.ink);

  static TextStyle get caption => body(12.5, color: AppColors.inkMuted, height: 1.35);

  static TextStyle get label =>
      body(13.5, weight: FontWeight.w600, color: AppColors.ink);

  static TextStyle get button =>
      body(15, weight: FontWeight.w600, color: AppColors.white);

  /// "सभी देखें" / "See all" trailing links.
  static TextStyle get link =>
      body(13.5, weight: FontWeight.w600, color: AppColors.terracotta);

  static TextStyle get navLabel => body(11.5, weight: FontWeight.w500);
}
