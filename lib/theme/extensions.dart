import 'package:flutter/material.dart';
import 'colors.dart';

// Custom theme extensions for specific components
class EstuaireThemeExtensions {
  // Button themes
  static ButtonStyle get primaryButton => ElevatedButton.styleFrom(
        backgroundColor: EstuaireColors.primary600,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        elevation: 0,
        shadowColor: Colors.transparent,
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return EstuaireColors.primary700.withOpacity(0.1);
            }
            return null;
          },
        ),
      );

  static ButtonStyle get secondaryButton => OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: EstuaireColors.gray700,
        side: BorderSide(color: EstuaireColors.gray300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return EstuaireColors.gray50.withOpacity(0.5);
            }
            return null;
          },
        ),
      );

  static ButtonStyle get blueButton => ElevatedButton.styleFrom(
        backgroundColor: EstuaireColors.secondary500,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        elevation: 0,
        shadowColor: Colors.transparent,
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return EstuaireColors.secondary600.withOpacity(0.1);
            }
            return null;
          },
        ),
      );

  static ButtonStyle get dangerButton => ElevatedButton.styleFrom(
        backgroundColor: EstuaireColors.danger,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        elevation: 0,
        shadowColor: Colors.transparent,
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return EstuaireColors.danger.withOpacity(0.1);
            }
            return null;
          },
        ),
      );

  // Card theme
  static CardThemeData get cardTheme => CardThemeData(
        color: EstuaireColors.cardLight,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: EstuaireColors.gray200.withOpacity(0.6),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
      );

  // Input field theme
  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: EstuaireColors.gray300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: EstuaireColors.gray300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: EstuaireColors.primary500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: EstuaireColors.danger, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: EstuaireColors.danger, width: 2),
        ),
        labelStyle: TextStyle(color: EstuaireColors.gray500),
        hintStyle: TextStyle(color: EstuaireColors.gray400),
      );

  // Table theme
  static DataTableThemeData get tableTheme => DataTableThemeData(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: EstuaireColors.gray200.withOpacity(0.6),
            width: 1,
          ),
        ),
        headingRowColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) => EstuaireColors.gray50,
        ),
        headingTextStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: EstuaireColors.gray500,
          letterSpacing: 1.2,
          textBaseline: TextBaseline.alphabetic,
        ),
        dataTextStyle: TextStyle(
          fontSize: 14,
          color: EstuaireColors.gray700,
        ),
        dividerThickness: 1,
        horizontalMargin: 16,
        dataRowMinHeight: 48,
        dataRowMaxHeight: 48,
      );
}