import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  /// 🌈 Brand color (only input)
  static const Color primaryColor = Colors.blue;
  static const Color red = Colors.red;

  /* ───────────────── GRADIENT ───────────────── */

  static List<Color> generateGradientColors() {
    final hsl = HSLColor.fromColor(primaryColor);

    return [
      hsl.withLightness(0.88).toColor(), // light
      primaryColor, // base
      hsl.withLightness(0.32).toColor(), // dark
    ];
  }

  /* ───────────────── TEXT COLORS ───────────────── */

  /// Auto contrast text for gradient background
  static Color get textOnGradient {
    final brightness = ThemeData.estimateBrightnessForColor(primaryColor);
    return brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  /// Primary body text (neutral, readable)
  static Color get textPrimary {
    final hsl = HSLColor.fromColor(primaryColor);
    return hsl.withSaturation(0.08).withLightness(0.1).toColor();
  }

  /// Secondary text (labels, hints)
  static Color get textSecondary {
    final hsl = HSLColor.fromColor(primaryColor);
    return hsl.withSaturation(0.06).withLightness(0.45).toColor();
  }

  /* ───────────────── BORDER COLORS ───────────────── */

  /// Default border (neutral)
  static Color get borderColor {
    final hsl = HSLColor.fromColor(primaryColor);
    return hsl.withSaturation(0.05).withLightness(0.9).toColor();
  }

  /// Focused border
  static Color get borderFocused {
    final hsl = HSLColor.fromColor(primaryColor);
    return hsl.withSaturation(0.12).withLightness(0.55).toColor();
  }

  /// Error border (fixed for UX clarity)
  static const Color borderError = Colors.redAccent;
}
