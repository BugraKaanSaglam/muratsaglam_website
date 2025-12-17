import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app.dart';

const _supportedLocales = [
  Locale('en'),
  Locale('tr'),
  Locale('de'),
  Locale('ar'),
  Locale('fa'),
];

/// Entry point with localization bootstrap.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final startLocale = _detectLocale();

  runApp(
    EasyLocalization(
      supportedLocales: _supportedLocales,
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: startLocale,
      useOnlyLangCode: true,
      child: const App(),
    ),
  );
}

/// Pick the best matching locale based on the user's browser/device settings.
Locale _detectLocale() {
  final platformLocales = ui.PlatformDispatcher.instance.locales;
  for (final locale in platformLocales) {
    for (final supported in _supportedLocales) {
      if (supported.languageCode.toLowerCase() ==
          locale.languageCode.toLowerCase()) {
        return supported;
      }
    }
  }
  return _supportedLocales.first;
}
