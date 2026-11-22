import 'package:flutter/material.dart';

/// ألوان التطبيق — أخضر عميق وذهبي.
class AppColors {
  AppColors._();

  static const Color deepGreen = Color(0xFF0D1F1A);
  static const Color deepGreenLight = Color(0xFF143129);
  static const Color emerald = Color(0xFF14532D);
  static const Color emeraldLight = Color(0xFF1E6B3A);
  static const Color gold = Color(0xFFC9A86A);
  static const Color goldLight = Color(0xFFE8D5A3);
  static const Color goldDark = Color(0xFF9A7B3F);
  static const Color cream = Color(0xFFFAF6EF);
  static const Color creamDark = Color(0xFFEDE4D3);

  static const Color lightBackground = Color(0xFFFAF6EF);
  static const Color lightCard = Colors.white;
  static const Color lightBorder = Color(0xFFE5DCC8);
  static const Color lightText = Color(0xFF1C2B25);
  static const Color lightMutedText = Color(0xFF6B7A70);

  static const Color darkBackground = Color(0xFF0D1F1A);
  static const Color darkCard = Color(0xFF143129);
  static const Color darkBorder = Color(0xFF2A4A3A);
  static const Color darkText = Color(0xFFFAF6EF);
  static const Color darkMutedText = Color(0xFFB9C4B2);

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color card(BuildContext context) =>
      isDark(context) ? darkCard : lightCard;

  static Color border(BuildContext context) =>
      isDark(context) ? darkBorder : lightBorder;

  static Color accent(BuildContext context) =>
      isDark(context) ? goldLight : emerald;

  static Color text(BuildContext context) =>
      isDark(context) ? darkText : lightText;

  static Color mutedText(BuildContext context) =>
      isDark(context) ? darkMutedText : lightMutedText;

  static Color background(BuildContext context) =>
      isDark(context) ? darkBackground : lightBackground;
}

/// خط أميري للنصوص القرآنية والعناوين.
TextStyle amiri({
  double size = 20,
  bool bold = false,
  Color? color,
  double? height,
}) {
  return TextStyle(
    fontFamily: 'Amiri',
    fontSize: size,
    fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
    color: color,
    height: height,
  );
}

/// خط القاهرة لواجهة التطبيق.
/// [weight] رقم من 100 إلى 900 مثل 400 و700 و800.
TextStyle cairo({
  double size = 16,
  int weight = 400,
  Color? color,
  double? height,
}) {
  final index = ((weight - 100) ~/ 100).clamp(0, 8);
  return TextStyle(
    fontFamily: 'Cairo',
    fontSize: size,
    fontWeight: FontWeight.values[index],
    color: color,
    height: height,
  );
}

/// ثيم التطبيق الفاتح والداكن.
class AppTheme {
  AppTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Cairo',
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.emerald,
        secondary: AppColors.gold,
        surface: AppColors.lightCard,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightText,
        elevation: 0,
        centerTitle: true,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightCard,
        indicatorColor: AppColors.gold.withValues(alpha: 0.35),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Cairo',
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        secondary: AppColors.emeraldLight,
        surface: AppColors.darkCard,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkText,
        elevation: 0,
        centerTitle: true,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkCard,
        indicatorColor: AppColors.gold.withValues(alpha: 0.35),
      ),
    );
  }
}
