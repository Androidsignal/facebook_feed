// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_feed_flutter/infrastructure/theme/app_colors.dart';

class AppTheme {

  ThemeData light() {
    var theme = ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.primaryColor,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        background: Colors.white,
      ),
    );
    return theme.copyWith(
      textTheme: GoogleFonts.getTextTheme(
        'Poppins',
        textTheme(theme, Colors.black87),
      ),
    );
  }

  ThemeData dark() {
    var theme = ThemeData(
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      scaffoldBackgroundColor: Colors.black,
      primaryColor: AppColors.primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryColor,
        secondary: AppColors.primaryColor,
      ),
    );
    return theme.copyWith(
      textTheme: GoogleFonts.getTextTheme(
        'Poppins',
        textTheme(theme),
      ),
    );
  }

  TextTheme textTheme(ThemeData theme, [Color? color]) {
    return TextTheme(
      displayMedium: theme.textTheme.displayMedium?.copyWith(color: color),
      displaySmall: theme.textTheme.displaySmall?.copyWith(color: color),
      headlineLarge: theme.textTheme.headlineLarge?.copyWith(color: color),
      headlineMedium: theme.textTheme.headlineMedium?.copyWith(color: color),
      headlineSmall: theme.textTheme.headlineSmall?.copyWith(color: color),
      titleLarge: theme.textTheme.titleLarge?.copyWith(color: color),
      titleMedium: theme.textTheme.titleMedium?.copyWith(color: color),
      titleSmall: theme.textTheme.titleSmall?.copyWith(color: color),
      bodyLarge: theme.textTheme.bodyLarge?.copyWith(color: color),
      bodyMedium: theme.textTheme.bodyMedium?.copyWith(color: color),
      bodySmall: theme.textTheme.bodySmall?.copyWith(color: color),
      labelLarge: theme.textTheme.labelLarge?.copyWith(color: color),
      labelMedium: theme.textTheme.labelMedium?.copyWith(color: color),
      labelSmall: theme.textTheme.labelSmall?.copyWith(color: color),
    );
  }

  bool isDarkMode(Brightness brightness) {
    return brightness == Brightness.dark;
  }
}

extension TextThemeExtention on BuildContext {
  TextStyle? get headline2 => Theme.of(this).textTheme.displayMedium;

  TextStyle? get headline3 => Theme.of(this).textTheme.displaySmall;

  TextStyle? get headline4 => Theme.of(this).textTheme.headlineMedium;

  TextStyle? get headline5 => Theme.of(this).textTheme.headlineSmall;

  TextStyle? get headline6 => Theme.of(this).textTheme.titleLarge;

  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;

  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;

  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;

  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;

  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;

  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;

  TextStyle? get labelLarge => Theme.of(this).textTheme.labelSmall?.copyWith(fontSize: 14);

  TextStyle? get labelMedium => Theme.of(this).textTheme.labelMedium?.copyWith(fontSize: 12);

  TextStyle? get labelSmall => Theme.of(this).textTheme.labelSmall;

  TextStyle? get caption => Theme.of(this).textTheme.bodySmall;

  Color? get iconColor => Theme.of(this).iconTheme.color;

  Color? get errorColor => Theme.of(this).colorScheme.error;

  Color? get primaryColor => Theme.of(this).colorScheme.primary;

  Color get disableColor => Colors.grey.withOpacity(.5);

  Color get cardColor => Theme.of(this).cardColor;

  Color? get textColor => Theme.of(this).brightness == Brightness.dark ? Colors.white : Colors.black;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
