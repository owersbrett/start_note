import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config_keys.dart';

abstract class ApplicationThemeBase {
  late Color appBarColor;
  late AppBarTheme appBarTheme;
}

class ApplicationThemeDark extends ApplicationThemeBase {
  static Map<ConfigKey, String> darkThemeDefault = {
    ConfigKey.appBarColor: '0xFF181818',
  };

  ApplicationThemeDark initialize() {
    appBarColor = Colors.amber;
    appBarTheme = AppBarTheme(color: appBarColor);

    return this;
  }

  Color getColor(ConfigKey key) {
    return Color(int.parse(darkThemeDefault[key]!));
  }
}

class ApplicationTheme {
  static ApplicationThemeBase? _currentTheme;

  ApplicationTheme._();

  static double fontSizeTitle = 28.0;
  static double fontSizeBody = 16.0;
  static double fontSizeCaption = 12.0;

  static ApplicationThemeBase get current {
    if (_currentTheme == null) {
      _currentTheme = ApplicationThemeDark().initialize();
    }
    return _currentTheme!;
  }

  static const mySystemTheme = SystemUiOverlayStyle.dark;
  static Color appBarColor = ApplicationTheme.appBarColor;
  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: Colors.amber,
    brightness: Brightness.dark,
  );

  static Map<String, dynamic> defaultThemeData = {
    'backgroundDark': '4279440924',
    'backgroundCardDark': '4279836455',
    'backgroundTabBarDark': '4280297522',
    'backgroundAppBarDark': '4280297522',
    'shadowDark': '4278190080',
    'primaryColorDark': '4284516327',
    'accentColorDark': '4294945600',
    'titleTextDark': '4294967295',
    'captionTextDark': '4286810775',
    'mutedCaptionTextDark': '4283257694',
    'bodyTextDark': '4294967295',
    'dividerDark': '4286810775',
    'buttonTextDark': '4294967295',
    'iconDark': '4294638330',
    'appBarIconDark': '4294638330',
    'tabBarIconDark': '4286810775',
    'tabBarSelectedDark': '4284516327',
    'lossDark': '4294198070',
  };
}

class Styles {
  static TextStyle text(double size, Color color, bool bold, {double? height}) {
    return TextStyle(
      fontSize: size,
      color: color,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      height: height,
    );
  }

  static TextStyle textColor(Color color) {
    return TextStyle(color: color);
  }
}
