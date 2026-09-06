import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Spacing, radii and elevation. Nothing hard-codes a number that lives here.
abstract final class Gap {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 28.0;
  static const section = 32.0;

  /// Standard horizontal page inset.
  static const page = 18.0;
}

abstract final class Radii {
  static const sm = BorderRadius.all(Radius.circular(8));
  static const md = BorderRadius.all(Radius.circular(12));
  static const lg = BorderRadius.all(Radius.circular(16));
  static const xl = BorderRadius.all(Radius.circular(20));
  static const pill = BorderRadius.all(Radius.circular(999));
}

abstract final class Shadows {
  /// Cards. Deliberately soft. Heavy shadows read as cheap.
  static const card = <BoxShadow>[
    BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 3)),
  ];

  static const floating = <BoxShadow>[
    BoxShadow(color: Color(0x1F000000), blurRadius: 18, offset: Offset(0, 6)),
  ];
}
