import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFFF7FAF8);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceSoft = Color(0xFFEEF3EF);
  static const text = Color(0xFF183126);
  static const textMuted = Color(0xFF567164);

  static const primary = Color(0xFF2BAE66);
  static const primaryDark = Color(0xFF1D8D50);
  static const accent = Color(0xFFF5B700);
  static const danger = Color(0xFFE14E50);

  static const border = Color(0xFFD7E4DB);

  // Legacy aliases for older screens/components still present in the repo.
  static const primaryDim = primaryDark;
  static const primaryContainer = Color(0xFFA8E7C5);
  static const primaryFixedDim = Color(0xFF7BD6A4);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onPrimaryContainer = text;

  static const secondary = Color(0xFF2D7DD2);
  static const secondaryDim = Color(0xFF1B5FA9);
  static const secondaryContainer = Color(0xFFC9E1FF);
  static const onSecondaryContainer = Color(0xFF123656);

  static const tertiary = Color(0xFF8A6A00);
  static const tertiaryDim = Color(0xFF705500);
  static const tertiaryContainer = Color(0xFFFFE08F);
  static const tertiaryFixedDim = Color(0xFFE6C56A);
  static const onTertiaryFixed = Color(0xFF4F3D00);
  static const onTertiaryContainer = Color(0xFF4F3D00);

  static const error = danger;
  static const errorDim = Color(0xFFB33A3B);
  static const errorContainer = Color(0xFFF8B8B9);
  static const onError = Color(0xFFFFFFFF);

  static const background = bg;
  static const surfaceContainerLowest = surface;
  static const surfaceContainerLow = surfaceSoft;
  static const surfaceContainer = Color(0xFFE8EFEA);
  static const surfaceContainerHigh = Color(0xFFDDE8E0);
  static const surfaceContainerHighest = Color(0xFFD4E1D8);
  static const surfaceDim = Color(0xFFC7D7CC);

  static const onBackground = text;
  static const onSurface = text;
  static const onSurfaceVariant = textMuted;

  static const outline = border;
  static const outlineVariant = Color(0xFFB8CABE);
}
