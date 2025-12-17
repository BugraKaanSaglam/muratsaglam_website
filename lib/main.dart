import 'dart:async';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app.dart';

const _supportedLocales = [Locale('en'), Locale('tr'), Locale('de'), Locale('ar'), Locale('fa')];

// Entry point with localization bootstrap.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await runZonedGuarded(
    () async {
      await EasyLocalization.ensureInitialized();

      final startLocale = _detectLocale();

      runApp(EasyLocalization(supportedLocales: _supportedLocales, path: 'assets/translations', fallbackLocale: const Locale('en'), startLocale: startLocale, useOnlyLangCode: true, child: const App()));
    },
    (error, stackTrace) {
      // If localization/assets fail to bootstrap, show a lightweight error screen
      // so the HTML loader is cleared instead of spinning forever.
      debugPrint('Startup error: $error\n$stackTrace');
      runApp(const _FatalErrorApp());
    },
  );
}

/// Pick the best matching locale based on the user's browser/device settings.
Locale _detectLocale() {
  final platformLocales = ui.PlatformDispatcher.instance.locales;
  for (final locale in platformLocales) {
    for (final supported in _supportedLocales) {
      if (supported.languageCode.toLowerCase() == locale.languageCode.toLowerCase()) {
        return supported;
      }
    }
  }
  return _supportedLocales.first;
}

class _FatalErrorApp extends StatelessWidget {
  const _FatalErrorApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Uygulama yüklenirken bir sorun oluştu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 12),
                Text('Lütfen sayfayı yenileyip tekrar deneyin.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
