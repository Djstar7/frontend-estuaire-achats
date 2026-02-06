import 'package:flutter/material.dart';
import 'colors.dart';
import 'extensions.dart';

// Main theme configuration for the Estuaire Achats app
class EstuaireTheme {
  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Primary colors
    primaryColor: EstuaireColors.primary500,
    colorScheme: ColorScheme.fromSeed(
      seedColor: EstuaireColors.primary500,
      brightness: Brightness.light,
      primary: EstuaireColors.primary500,
      secondary: EstuaireColors.secondary500,
      surface: EstuaireColors.surfaceLight,
      background: EstuaireColors.backgroundLight,
      error: EstuaireColors.danger,
    ).copyWith(
      outline: EstuaireColors.gray300,
      outlineVariant: EstuaireColors.gray200,
    ),
    
    // Typography
    textTheme: _textTheme(),
    
    // Components
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: EstuaireThemeExtensions.primaryButton,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: EstuaireThemeExtensions.secondaryButton,
    ),
    cardTheme: EstuaireThemeExtensions.cardTheme,
    inputDecorationTheme: EstuaireThemeExtensions.inputDecorationTheme,
    dataTableTheme: EstuaireThemeExtensions.tableTheme,
    
    // Scrollbar
    scrollbarTheme: ScrollbarThemeData(
      thumbVisibility: WidgetStateProperty.all(true),
      thickness: WidgetStateProperty.all(6),
      radius: const Radius.circular(6),
      thumbColor: WidgetStateProperty.all(EstuaireColors.gray300),
    ),
    
    // Other components
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: EstuaireColors.gray900,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: EstuaireColors.gray900,
      ),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.white,
      width: 280,
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: Colors.white,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      indicatorColor: EstuaireColors.primary50.withOpacity(0.5),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: EstuaireColors.primary500,
      unselectedItemColor: EstuaireColors.gray500,
      type: BottomNavigationBarType.fixed,
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Primary colors
    primaryColor: EstuaireColors.primary500,
    colorScheme: ColorScheme.fromSeed(
      seedColor: EstuaireColors.primary500,
      brightness: Brightness.dark,
      primary: EstuaireColors.primary500,
      secondary: EstuaireColors.secondary500,
      surface: EstuaireColors.surfaceDark,
      background: EstuaireColors.backgroundDark,
      error: EstuaireColors.danger,
    ).copyWith(
      outline: EstuaireColors.gray600,
      outlineVariant: EstuaireColors.gray700,
    ),
    
    // Typography
    textTheme: _textTheme(isDark: true),
    
    // Components
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: EstuaireThemeExtensions.primaryButton.copyWith(
        backgroundColor: WidgetStateProperty.all(EstuaireColors.primary700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: EstuaireThemeExtensions.secondaryButton.copyWith(
        backgroundColor: WidgetStateProperty.all(EstuaireColors.gray700),
        foregroundColor: WidgetStateProperty.all(EstuaireColors.gray200),
        side: WidgetStateProperty.all(BorderSide(color: EstuaireColors.gray600)),
      ),
    ),
    cardTheme: EstuaireThemeExtensions.cardTheme.copyWith(
      color: EstuaireColors.cardDark,
    ),
    inputDecorationTheme: EstuaireThemeExtensions.inputDecorationTheme.copyWith(
      fillColor: EstuaireColors.gray800,
      labelStyle: TextStyle(color: EstuaireColors.gray400),
      hintStyle: TextStyle(color: EstuaireColors.gray500),
    ),
    dataTableTheme: EstuaireThemeExtensions.tableTheme.copyWith(
      decoration: BoxDecoration(
        color: EstuaireColors.gray800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: EstuaireColors.gray700,
          width: 1,
        ),
      ),
      headingRowColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) => EstuaireColors.gray800,
      ),
      headingTextStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: EstuaireColors.gray400,
        letterSpacing: 1.2,
        textBaseline: TextBaseline.alphabetic,
      ),
      dataTextStyle: TextStyle(
        fontSize: 14,
        color: EstuaireColors.gray300,
      ),
    ),
    
    // Scrollbar
    scrollbarTheme: ScrollbarThemeData(
      thumbVisibility: WidgetStateProperty.all(true),
      thickness: WidgetStateProperty.all(6),
      radius: const Radius.circular(6),
      thumbColor: WidgetStateProperty.all(EstuaireColors.gray600),
    ),
    
    // Other components
    appBarTheme: AppBarTheme(
      backgroundColor: EstuaireColors.backgroundDark,
      foregroundColor: EstuaireColors.gray100,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: EstuaireColors.gray100,
      ),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: EstuaireColors.backgroundDark,
      width: 280,
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: EstuaireColors.backgroundDark,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      indicatorColor: EstuaireColors.primary950.withOpacity(0.5),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: EstuaireColors.backgroundDark,
      selectedItemColor: EstuaireColors.primary300,
      unselectedItemColor: EstuaireColors.gray500,
      type: BottomNavigationBarType.fixed,
    ),
  );

  // Text theme configuration
  static TextTheme _textTheme({bool isDark = false}) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: isDark ? EstuaireColors.gray100 : EstuaireColors.gray900,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: isDark ? EstuaireColors.gray100 : EstuaireColors.gray900,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: isDark ? EstuaireColors.gray100 : EstuaireColors.gray900,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: isDark ? EstuaireColors.gray100 : EstuaireColors.gray900,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: isDark ? EstuaireColors.gray100 : EstuaireColors.gray900,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: isDark ? EstuaireColors.gray100 : EstuaireColors.gray900,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: isDark ? EstuaireColors.gray100 : EstuaireColors.gray900,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: isDark ? EstuaireColors.gray100 : EstuaireColors.gray900,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? EstuaireColors.gray300 : EstuaireColors.gray600,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: isDark ? EstuaireColors.gray200 : EstuaireColors.gray800,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: isDark ? EstuaireColors.gray200 : EstuaireColors.gray700,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: isDark ? EstuaireColors.gray400 : EstuaireColors.gray600,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? EstuaireColors.gray200 : EstuaireColors.gray800,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: isDark ? EstuaireColors.gray300 : EstuaireColors.gray600,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: isDark ? EstuaireColors.gray400 : EstuaireColors.gray500,
      ),
    );
  }
}