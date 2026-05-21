import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background Colors
  static const Color bgPrimary = Color(0xFF0D1117);
  static const Color bgSecondary = Color(0xFF161B22);
  static const Color bgCard = Color(0xFF1C2333);
  static const Color bgCardHover = Color(0xFF21273D);

  // Accent Colors
  static const Color accent = Color(0xFF00D9A6);
  static const Color accentLight = Color(0xFF33E0B8);
  static const Color accentDark = Color(0xFF00B389);
  static const Color accentGlow = Color(0x2600D9A6);

  // Text Colors
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF484F58);

  // Border Colors
  static const Color border = Color(0xFF30363D);
  static const Color borderHover = Color(0xFF00D9A6);

  // Skill chip colors
  static const Color chipBg = Color(0xFF0D2137);
  static const Color chipBorder = Color(0xFF1A4A6B);

  // Timeline
  static const Color timelineLine = Color(0xFF30363D);
  static const Color timelineDot = Color(0xFF00D9A6);

  // Gradient
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D1117), Color(0xFF0D2137)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00D9A6), Color(0xFF00B3FF)],
  );
}
