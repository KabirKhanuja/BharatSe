import 'package:flutter/material.dart';

/// BharatSe palette.
/// Warm, paper-like and deliberately unlike generic e-commerce blue-and-white.
/// Every colour used anywhere in the app must come from this file.
abstract final class AppColors {
  // Grounds
  static const cream = Color(0xFFFAF6F0); // page background
  static const creamAlt = Color(0xFFF3EDE4); // inset panels, wells
  static const white = Color(0xFFFFFFFF); // cards
  static const line = Color(0xFFE7E0D5); // hairlines, dividers, borders

  // Text
  static const ink = Color(0xFF1E1B16); // primary text, warm near-black
  static const inkMuted = Color(0xFF6E665A); // secondary text
  static const inkFaint = Color(0xFF9A9182); // captions, placeholders

  // Brand
  static const navy = Color(0xFF16324F); // wordmark, primary buttons, headlines
  static const navyDeep = Color(0xFF0F2439); // pressed states
  static const terracotta = Color(0xFFB4522C); // accents, region labels, links
  static const maroon = Color(0xFF8F1D24); // the publish CTA, mic button
  static const gold = Color(0xFFC6A24C); // ornaments, dividers

  // Status
  static const success = Color(0xFF2E6B4F);
  static const warning = Color(0xFFB8860B);
  static const offline = Color(0xFF7A6E5D); // queued / no signal states

  // Scrims
  static const scrim = Color(0x66000000);
  static const shadow = Color(0x14000000);
}
