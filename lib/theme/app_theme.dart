import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Color Scheme
  static const Color primaryColor = Color(0xFFFF6B00); // Deep orange
  static const Color secondaryColor = Color(0xFF212121); // Near black
  static const Color accentColor = Color(0xFFFFC107); // Amber
  static const Color backgroundColor = Color(0xFFFAFAFA); // Light grey background
  static const Color cardColor = Colors.white;
  static const Color errorColor = Color(0xFFE53935); // Red
  static const Color successColor = Color(0xFF43A047); // Green
  
  // Text colors
  static const Color primaryTextColor = Color(0xFF212121); // Dark text
  static const Color secondaryTextColor = Color(0xFF757575); // Grey text
  static const Color lightTextColor = Colors.white;
  
  // Shadow
  static BoxShadow defaultShadow = BoxShadow(
    color: Colors.black.withOpacity(0.08),
    blurRadius: 8,
    offset: const Offset(0, 2),
  );

  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXL = 24.0;

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;

  // Button Styles
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusMedium),
    ),
    elevation: 0,
  );
  
  static ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: primaryColor,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusMedium),
      side: const BorderSide(color: primaryColor),
    ),
    elevation: 0,
  );

  // Card Decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(borderRadiusMedium),
    boxShadow: [defaultShadow],
  );

  // Input Decoration
  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadiusMedium),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadiusMedium),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadiusMedium),
      borderSide: const BorderSide(color: primaryColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadiusMedium),
      borderSide: const BorderSide(color: errorColor),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );

  // App Bar Theme
  static AppBarTheme appBarTheme = const AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(borderRadiusLarge),
      ),
    ),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: Colors.white,
    ),
  );

  // Bottom Navigation Bar Theme
  static BottomNavigationBarThemeData bottomNavBarTheme = const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: primaryColor,
    unselectedItemColor: secondaryTextColor,
    selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    unselectedLabelStyle: TextStyle(fontSize: 12),
    showSelectedLabels: true,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  );

  // Chip Theme
  static ChipThemeData chipThemeData = ChipThemeData(
    backgroundColor: Colors.grey.shade200,
    disabledColor: Colors.grey.shade300,
    selectedColor: primaryColor,
    secondarySelectedColor: primaryColor,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    labelStyle: const TextStyle(
      fontSize: 14,
      color: secondaryTextColor,
      fontWeight: FontWeight.w500,
    ),
    secondaryLabelStyle: const TextStyle(
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
    brightness: Brightness.light,
  );

  // Get ThemeData for the app
  static ThemeData getThemeData() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
      ),
      appBarTheme: appBarTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: primaryButtonStyle,
      ),
      inputDecorationTheme: inputDecorationTheme,
      bottomNavigationBarTheme: bottomNavBarTheme,
      chipTheme: chipThemeData,
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        color: cardColor,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: secondaryColor,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
        ),
      ),
      textTheme: TextTheme(
        // Title styles
        displayLarge: const TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          color: primaryTextColor,
          height: 1.2,
        ),
        displayMedium: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: primaryTextColor,
        ),
        displaySmall: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
        ),
        titleLarge: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
        ),
        titleMedium: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: primaryTextColor,
        ),
        titleSmall: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: primaryTextColor,
        ),
        // Body styles
        bodyLarge: const TextStyle(
          fontSize: 16.0, 
          color: primaryTextColor,
          height: 1.5,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14.0,
          color: primaryTextColor,
          height: 1.5,
        ),
        bodySmall: const TextStyle(
          fontSize: 12.0,
          color: secondaryTextColor,
        ),
        // Label styles
        labelLarge: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: Colors.white,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFEEEEEE),
        thickness: 1,
        space: 32,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return null;
        }),
      ),
      splashColor: primaryColor.withOpacity(0.1),
      highlightColor: primaryColor.withOpacity(0.05),
    );
  }
}
