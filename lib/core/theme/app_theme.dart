import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => _buildTheme(Brightness.light, AppColors.light);
  static ThemeData get darkTheme => _buildTheme(Brightness.dark, AppColors.dark);

  static ThemeData _buildTheme(Brightness brightness, AppColorsExtension colors) {
    final colorScheme = _buildColorScheme(brightness, colors);
    final textTheme = _buildTextTheme(colors);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colors.background,
      appBarTheme: _appBarTheme(textTheme, colors),
      cardTheme: _cardTheme(colors),
      elevatedButtonTheme: _elevatedButtonTheme(textTheme, colors),
      outlinedButtonTheme: _outlinedButtonTheme(textTheme, colors),
      textButtonTheme: _textButtonTheme(textTheme, colors),
      inputDecorationTheme: _inputDecorationTheme(textTheme, colors),
      bottomNavigationBarTheme: _bottomNavBarTheme(colors),
      floatingActionButtonTheme: _fabTheme(colors),
      chipTheme: _chipTheme(textTheme, colors),
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
        space: 0,
      ),
      snackBarTheme: _snackBarTheme(textTheme, colors),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: colors.cardBackground,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.cardBackground,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.onPrimary;
          }
          return colors.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primaryContainer;
          }
          return colors.surfaceContainerHighest;
        }),
      ),
      extensions: [colors],
    );
  }

  static ColorScheme _buildColorScheme(Brightness brightness, AppColorsExtension colors) {
    return ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      primaryContainer: colors.primaryContainer,
      onPrimaryContainer: colors.onPrimaryContainer,
      secondary: colors.secondary,
      onSecondary: colors.onSecondary,
      secondaryContainer: colors.secondaryContainer,
      onSecondaryContainer: colors.onSecondaryContainer,
      tertiary: colors.tertiary,
      onTertiary: colors.onTertiary,
      tertiaryContainer: colors.tertiaryContainer,
      onTertiaryContainer: colors.onTertiaryContainer,
      error: colors.error,
      onError: colors.onError,
      errorContainer: colors.errorContainer,
      onErrorContainer: colors.onErrorContainer,
      surface: colors.surface,
      onSurface: colors.onSurface,
      onSurfaceVariant: colors.onSurfaceVariant,
      outline: colors.outline,
      outlineVariant: colors.outlineVariant,
      inverseSurface: colors.inverseSurface,
      onInverseSurface: colors.inverseOnSurface,
      inversePrimary: colors.inversePrimary,
      surfaceTint: colors.surfaceTint,
    );
  }

  static TextTheme _buildTextTheme(AppColorsExtension colors) {
    return GoogleFonts.plusJakartaSansTextTheme().copyWith(
      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 32 / 24,
        letterSpacing: -0.24,
        color: colors.textPrimary,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: colors.textPrimary,
      ),
      headlineSmall: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 26 / 18,
        color: colors.textPrimary,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 26 / 18,
        color: colors.textPrimary,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
        color: colors.textPrimary,
      ),
      titleSmall: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        color: colors.textPrimary,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: colors.textPrimary,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: colors.textPrimary,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
        color: colors.textSecondary,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        color: colors.textPrimary,
      ),
      labelMedium: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 16 / 12,
        letterSpacing: 0.6,
        color: colors.textSecondary,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 16 / 11,
        letterSpacing: 0.5,
        color: colors.textSecondary,
      ),
    );
  }

  static AppBarTheme _appBarTheme(TextTheme textTheme, AppColorsExtension colors) {
    return AppBarTheme(
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: true,
      titleTextStyle: textTheme.titleMedium?.copyWith(
        color: colors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(
        color: colors.onSurface,
        size: 24,
      ),
    );
  }

  static CardThemeData _cardTheme(AppColorsExtension colors) {
    return CardThemeData(
      color: colors.cardBackground,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      margin: EdgeInsets.zero,
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(TextTheme textTheme, AppColorsExtension colors) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: textTheme.labelLarge?.copyWith(
          color: colors.onPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(TextTheme textTheme, AppColorsExtension colors) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.primary,
        side: BorderSide(color: colors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: textTheme.labelLarge?.copyWith(
          color: colors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(TextTheme textTheme, AppColorsExtension colors) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colors.primary,
        textStyle: textTheme.labelLarge?.copyWith(
          color: colors.primary,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(TextTheme textTheme, AppColorsExtension colors) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colors.cardBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.inputFocusBorder, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.error, width: 2),
      ),
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: colors.textHint,
      ),
      labelStyle: textTheme.bodyMedium?.copyWith(
        color: colors.textSecondary,
      ),
      floatingLabelStyle: textTheme.bodySmall?.copyWith(
        color: colors.primary,
        fontWeight: FontWeight.w600,
      ),
      errorStyle: textTheme.bodySmall?.copyWith(
        color: colors.error,
      ),
    );
  }

  static BottomNavigationBarThemeData _bottomNavBarTheme(AppColorsExtension colors) {
    return BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: colors.navBackground,
      selectedItemColor: colors.navIconActive,
      unselectedItemColor: colors.navIconInactive,
      elevation: 0,
      selectedLabelStyle: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  static FloatingActionButtonThemeData _fabTheme(AppColorsExtension colors) {
    return FloatingActionButtonThemeData(
      backgroundColor: colors.primaryContainer,
      foregroundColor: colors.onPrimary,
      elevation: 4,
      shape: const CircleBorder(),
    );
  }

  static ChipThemeData _chipTheme(TextTheme textTheme, AppColorsExtension colors) {
    return ChipThemeData(
      backgroundColor: colors.chipBackground,
      labelStyle: textTheme.bodySmall?.copyWith(
        color: colors.chipText,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      side: BorderSide.none,
    );
  }

  static SnackBarThemeData _snackBarTheme(TextTheme textTheme, AppColorsExtension colors) {
    return SnackBarThemeData(
      backgroundColor: colors.inverseSurface,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: colors.inverseOnSurface,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
      insetPadding: const EdgeInsets.all(16),
    );
  }

  static List<BoxShadow> cardShadow(AppColorsExtension colors) => [
        BoxShadow(
          color: colors.shadowLight,
          offset: const Offset(0, 4),
          blurRadius: 12,
        ),
      ];

  static List<BoxShadow> elevatedShadow(AppColorsExtension colors) => [
        BoxShadow(
          color: colors.shadowMedium,
          offset: const Offset(0, 8),
          blurRadius: 20,
        ),
      ];
}
