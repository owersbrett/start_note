import 'dart:io';
import 'package:flutter/material.dart';

class L10nService {
  static L10nService get instance => L10nService();
  factory L10nService() => _singleton;
  static final L10nService _singleton = L10nService._init();

  static T of<T>(BuildContext context) => Localizations.of<T>(context, T)!;

  static final List<LocalizationsDelegate<dynamic>> delegates = [
    // AuthPageL10N.delegate,
  ];

  static const Locale enUS = Locale.fromSubtags(languageCode: 'en', countryCode: 'US');
  static const Locale esES = Locale.fromSubtags(languageCode: 'es', countryCode: 'ES');
  static const List<Locale> locales = [enUS];
  static const Locale defaultLocale = enUS;
  static bool isSupported(Locale locale) => locales.contains(locale);

  L10nService._init();

  Locale getCurrentLocale() {
    final platformLocale = getPlatformLocale();
    if (isSupported(platformLocale)) {
      return platformLocale;
    }
    for (var i = 0; i < locales.length; i++) {
      if (platformLocale.languageCode == locales[i].languageCode) {
        return locales[i];
      }
    }
    return defaultLocale;
  }

  Locale getPlatformLocale() {
    String localeString = Platform.localeName;
    localeString = '${defaultLocale.languageCode}-${defaultLocale.countryCode}';

    List<String> codes = localeString.split('-');
    if (codes.length == 1) {
      codes = localeString.split('_');
    }

    if (codes.length == 2) {
      return Locale(codes[0], codes[1]);
    } else if (codes.length == 1) {
      return Locale(codes[0]);
    } else {
      return defaultLocale;
    }
  }
}
