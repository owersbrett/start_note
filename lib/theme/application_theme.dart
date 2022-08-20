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

  static const Color grey = Colors.grey;
  static const Color red = Color(0xffF45B69); // fiery rose
  static const Color yellow = Color(0xffFFBF00); // amber
  static const Color createGreen = Color(0xff04724D); // dark spring green
  static const Color green = createGreen;
  static const Color viewGreen = Color(0xff8DB38B); // dark sea green
  static const Color altGreen = Color(0xff56876D); // viridian

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
    appBarTheme: AppBarTheme(),
    scaffoldBackgroundColor: Colors.amber,
    brightness: Brightness.dark,
    // floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Color(0xFF151026))
  );

  static Map<String, dynamic> defaultThemeData = {'backgroundDark': '4279440924'};
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
