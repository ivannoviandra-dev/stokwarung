import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  // ─── Primary ───
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color inversePrimary;

  // ─── Secondary ───
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;

  // ─── Tertiary ───
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;

  // ─── Error ───
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;

  // ─── Surface / Background ───
  final Color surface;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color surfaceTint;
  final Color surfaceVariant;

  // ─── Outline ───
  final Color outline;
  final Color outlineVariant;

  // ─── Background ───
  final Color background;
  final Color cardBackground;

  // ─── Fixed Colors ───
  final Color primaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixed;
  final Color onPrimaryFixedVariant;

  // ─── Typography Colors ───
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;

  // ─── Utility Colors ───
  final Color success;
  final Color warning;
  final Color warningLight;
  final Color dangerLight;
  final Color info;

  // ─── Input / Border ───
  final Color inputBorder;
  final Color inputFocusBorder;
  final Color divider;

  // ─── Shadows ───
  final Color shadowLight;
  final Color shadowMedium;

  // ─── Chip / Tag ───
  final Color chipBackground;
  final Color chipText;

  // ─── Status ───
  final Color statusActive;
  final Color statusInactive;
  final Color statusDanger;
  final Color statusWarning;
  final Color statusPending;

  // ─── Nav ───
  final Color navBackground;
  final Color navIconInactive;
  final Color navIconActive;

  const AppColorsExtension({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.inversePrimary,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.surface,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.surfaceTint,
    required this.surfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.background,
    required this.cardBackground,
    required this.primaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixed,
    required this.onPrimaryFixedVariant,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.success,
    required this.warning,
    required this.warningLight,
    required this.dangerLight,
    required this.info,
    required this.inputBorder,
    required this.inputFocusBorder,
    required this.divider,
    required this.shadowLight,
    required this.shadowMedium,
    required this.chipBackground,
    required this.chipText,
    required this.statusActive,
    required this.statusInactive,
    required this.statusDanger,
    required this.statusWarning,
    required this.statusPending,
    required this.navBackground,
    required this.navIconInactive,
    required this.navIconActive,
  });

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? inversePrimary,
    Color? secondary,
    Color? onSecondary,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? error,
    Color? onError,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? surface,
    Color? surfaceDim,
    Color? surfaceBright,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? inverseSurface,
    Color? inverseOnSurface,
    Color? surfaceTint,
    Color? surfaceVariant,
    Color? outline,
    Color? outlineVariant,
    Color? background,
    Color? cardBackground,
    Color? primaryFixed,
    Color? primaryFixedDim,
    Color? onPrimaryFixed,
    Color? onPrimaryFixedVariant,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? success,
    Color? warning,
    Color? warningLight,
    Color? dangerLight,
    Color? info,
    Color? inputBorder,
    Color? inputFocusBorder,
    Color? divider,
    Color? shadowLight,
    Color? shadowMedium,
    Color? chipBackground,
    Color? chipText,
    Color? statusActive,
    Color? statusInactive,
    Color? statusDanger,
    Color? statusWarning,
    Color? statusPending,
    Color? navBackground,
    Color? navIconInactive,
    Color? navIconActive,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      inversePrimary: inversePrimary ?? this.inversePrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
      tertiary: tertiary ?? this.tertiary,
      onTertiary: onTertiary ?? this.onTertiary,
      tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer ?? this.onTertiaryContainer,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      errorContainer: errorContainer ?? this.errorContainer,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      surface: surface ?? this.surface,
      surfaceDim: surfaceDim ?? this.surfaceDim,
      surfaceBright: surfaceBright ?? this.surfaceBright,
      surfaceContainerLowest: surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest: surfaceContainerHighest ?? this.surfaceContainerHighest,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      inverseSurface: inverseSurface ?? this.inverseSurface,
      inverseOnSurface: inverseOnSurface ?? this.inverseOnSurface,
      surfaceTint: surfaceTint ?? this.surfaceTint,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      background: background ?? this.background,
      cardBackground: cardBackground ?? this.cardBackground,
      primaryFixed: primaryFixed ?? this.primaryFixed,
      primaryFixedDim: primaryFixedDim ?? this.primaryFixedDim,
      onPrimaryFixed: onPrimaryFixed ?? this.onPrimaryFixed,
      onPrimaryFixedVariant: onPrimaryFixedVariant ?? this.onPrimaryFixedVariant,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      warningLight: warningLight ?? this.warningLight,
      dangerLight: dangerLight ?? this.dangerLight,
      info: info ?? this.info,
      inputBorder: inputBorder ?? this.inputBorder,
      inputFocusBorder: inputFocusBorder ?? this.inputFocusBorder,
      divider: divider ?? this.divider,
      shadowLight: shadowLight ?? this.shadowLight,
      shadowMedium: shadowMedium ?? this.shadowMedium,
      chipBackground: chipBackground ?? this.chipBackground,
      chipText: chipText ?? this.chipText,
      statusActive: statusActive ?? this.statusActive,
      statusInactive: statusInactive ?? this.statusInactive,
      statusDanger: statusDanger ?? this.statusDanger,
      statusWarning: statusWarning ?? this.statusWarning,
      statusPending: statusPending ?? this.statusPending,
      navBackground: navBackground ?? this.navBackground,
      navIconInactive: navIconInactive ?? this.navIconInactive,
      navIconActive: navIconActive ?? this.navIconActive,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
      covariant ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primaryContainer: Color.lerp(primaryContainer, other.primaryContainer, t)!,
      onPrimaryContainer: Color.lerp(onPrimaryContainer, other.onPrimaryContainer, t)!,
      inversePrimary: Color.lerp(inversePrimary, other.inversePrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      secondaryContainer: Color.lerp(secondaryContainer, other.secondaryContainer, t)!,
      onSecondaryContainer: Color.lerp(onSecondaryContainer, other.onSecondaryContainer, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      onTertiary: Color.lerp(onTertiary, other.onTertiary, t)!,
      tertiaryContainer: Color.lerp(tertiaryContainer, other.tertiaryContainer, t)!,
      onTertiaryContainer: Color.lerp(onTertiaryContainer, other.onTertiaryContainer, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      onErrorContainer: Color.lerp(onErrorContainer, other.onErrorContainer, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceDim: Color.lerp(surfaceDim, other.surfaceDim, t)!,
      surfaceBright: Color.lerp(surfaceBright, other.surfaceBright, t)!,
      surfaceContainerLowest: Color.lerp(surfaceContainerLowest, other.surfaceContainerLowest, t)!,
      surfaceContainerLow: Color.lerp(surfaceContainerLow, other.surfaceContainerLow, t)!,
      surfaceContainer: Color.lerp(surfaceContainer, other.surfaceContainer, t)!,
      surfaceContainerHigh: Color.lerp(surfaceContainerHigh, other.surfaceContainerHigh, t)!,
      surfaceContainerHighest: Color.lerp(surfaceContainerHighest, other.surfaceContainerHighest, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceVariant: Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t)!,
      inverseSurface: Color.lerp(inverseSurface, other.inverseSurface, t)!,
      inverseOnSurface: Color.lerp(inverseOnSurface, other.inverseOnSurface, t)!,
      surfaceTint: Color.lerp(surfaceTint, other.surfaceTint, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      background: Color.lerp(background, other.background, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      primaryFixed: Color.lerp(primaryFixed, other.primaryFixed, t)!,
      primaryFixedDim: Color.lerp(primaryFixedDim, other.primaryFixedDim, t)!,
      onPrimaryFixed: Color.lerp(onPrimaryFixed, other.onPrimaryFixed, t)!,
      onPrimaryFixedVariant: Color.lerp(onPrimaryFixedVariant, other.onPrimaryFixedVariant, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningLight: Color.lerp(warningLight, other.warningLight, t)!,
      dangerLight: Color.lerp(dangerLight, other.dangerLight, t)!,
      info: Color.lerp(info, other.info, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      inputFocusBorder: Color.lerp(inputFocusBorder, other.inputFocusBorder, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      shadowLight: Color.lerp(shadowLight, other.shadowLight, t)!,
      shadowMedium: Color.lerp(shadowMedium, other.shadowMedium, t)!,
      chipBackground: Color.lerp(chipBackground, other.chipBackground, t)!,
      chipText: Color.lerp(chipText, other.chipText, t)!,
      statusActive: Color.lerp(statusActive, other.statusActive, t)!,
      statusInactive: Color.lerp(statusInactive, other.statusInactive, t)!,
      statusDanger: Color.lerp(statusDanger, other.statusDanger, t)!,
      statusWarning: Color.lerp(statusWarning, other.statusWarning, t)!,
      statusPending: Color.lerp(statusPending, other.statusPending, t)!,
      navBackground: Color.lerp(navBackground, other.navBackground, t)!,
      navIconInactive: Color.lerp(navIconInactive, other.navIconInactive, t)!,
      navIconActive: Color.lerp(navIconActive, other.navIconActive, t)!,
    );
  }
}

class AppColors {
  AppColors._();

  static const AppColorsExtension light = AppColorsExtension(
    primary: Color(0xFF006E25),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF28A745),
    onPrimaryContainer: Color(0xFF00330D),
    inversePrimary: Color(0xFF66DF75),
    secondary: Color(0xFF5F5E5E),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFE5E2E1),
    onSecondaryContainer: Color(0xFF656464),
    tertiary: Color(0xFF55615A),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFF88958D),
    onTertiaryContainer: Color(0xFF222D28),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF93000A),
    surface: Color(0xFFF8F9FF),
    surfaceDim: Color(0xFFCBDBF5),
    surfaceBright: Color(0xFFF8F9FF),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFEFF4FF),
    surfaceContainer: Color(0xFFE5EEFF),
    surfaceContainerHigh: Color(0xFFDCE9FF),
    surfaceContainerHighest: Color(0xFFD3E4FE),
    onSurface: Color(0xFF0B1C30),
    onSurfaceVariant: Color(0xFF3E4A3C),
    inverseSurface: Color(0xFF213145),
    inverseOnSurface: Color(0xFFEAF1FF),
    surfaceTint: Color(0xFF006E25),
    surfaceVariant: Color(0xFFD3E4FE),
    outline: Color(0xFF6E7B6B),
    outlineVariant: Color(0xFFBDCAB9),
    background: Color(0xFFFAFAFA),
    cardBackground: Color(0xFFFFFFFF),
    primaryFixed: Color(0xFF83FC8E),
    primaryFixedDim: Color(0xFF66DF75),
    onPrimaryFixed: Color(0xFF002106),
    onPrimaryFixedVariant: Color(0xFF00531A),
    textPrimary: Color(0xFF1E293B),
    textSecondary: Color(0xFF6C757D),
    textHint: Color(0xFF94A3B8),
    success: Color(0xFF28A745),
    warning: Color(0xFFF59E0B),
    warningLight: Color(0xFFFFF3CD),
    dangerLight: Color(0xFFFFE4E1),
    info: Color(0xFF3B82F6),
    inputBorder: Color(0xFFE2E8F0),
    inputFocusBorder: Color(0xFF006E25),
    divider: Color(0xFFE2E8F0),
    shadowLight: Color(0x0A000000),
    shadowMedium: Color(0x14000000),
    chipBackground: Color(0xFFF1F5F9),
    chipText: Color(0xFF64748B),
    statusActive: Color(0xFF28A745),
    statusInactive: Color(0xFF6C757D),
    statusDanger: Color(0xFFDC3545),
    statusWarning: Color(0xFFF59E0B),
    statusPending: Color(0xFFFF8C00),
    navBackground: Color(0xF2FFFFFF),
    navIconInactive: Color(0xFF94A3B8),
    navIconActive: Color(0xFF006E25),
  );

  static const AppColorsExtension dark = AppColorsExtension(
    primary: Color(0xFF66DF75),
    onPrimary: Color(0xFF003910),
    primaryContainer: Color(0xFF00531A),
    onPrimaryContainer: Color(0xFF83FC8E),
    inversePrimary: Color(0xFF006E25),
    secondary: Color(0xFFC9C6C5),
    onSecondary: Color(0xFF303030),
    secondaryContainer: Color(0xFF474747),
    onSecondaryContainer: Color(0xFFE5E2E1),
    tertiary: Color(0xFFBCCBC2),
    onTertiary: Color(0xFF27322D),
    tertiaryContainer: Color(0xFF3E4943),
    onTertiaryContainer: Color(0xFFD8E7DD),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF0F172A),
    surfaceDim: Color(0xFF0B1120),
    surfaceBright: Color(0xFF1E293B),
    surfaceContainerLowest: Color(0xFF0F172A),
    surfaceContainerLow: Color(0xFF1E293B),
    surfaceContainer: Color(0xFF334155),
    surfaceContainerHigh: Color(0xFF475569),
    surfaceContainerHighest: Color(0xFF64748B),
    onSurface: Color(0xFFF8FAFC),
    onSurfaceVariant: Color(0xFFCBD5E1),
    inverseSurface: Color(0xFFE2E8F0),
    inverseOnSurface: Color(0xFF0F172A),
    surfaceTint: Color(0xFF66DF75),
    surfaceVariant: Color(0xFF334155),
    outline: Color(0xFF8C9888),
    outlineVariant: Color(0xFF424940),
    background: Color(0xFF0F172A),
    cardBackground: Color(0xFF1E293B),
    primaryFixed: Color(0xFF83FC8E),
    primaryFixedDim: Color(0xFF66DF75),
    onPrimaryFixed: Color(0xFF002106),
    onPrimaryFixedVariant: Color(0xFF00531A),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
    textHint: Color(0xFF64748B),
    success: Color(0xFF28A745),
    warning: Color(0xFFF59E0B),
    warningLight: Color(0xFF78350F),
    dangerLight: Color(0xFF7F1D1D),
    info: Color(0xFF3B82F6),
    inputBorder: Color(0xFF334155),
    inputFocusBorder: Color(0xFF66DF75),
    divider: Color(0xFF334155),
    shadowLight: Color(0x33000000),
    shadowMedium: Color(0x66000000),
    chipBackground: Color(0xFF334155),
    chipText: Color(0xFFCBD5E1),
    statusActive: Color(0xFF28A745),
    statusInactive: Color(0xFF6C757D),
    statusDanger: Color(0xFFDC3545),
    statusWarning: Color(0xFFF59E0B),
    statusPending: Color(0xFFFF8C00),
    navBackground: Color(0xF21E293B),
    navIconInactive: Color(0xFF64748B),
    navIconActive: Color(0xFF66DF75),
  );
}

extension AppThemeContext on BuildContext {
  AppColorsExtension get appColors => Theme.of(this).extension<AppColorsExtension>() ?? AppColors.light;
}
