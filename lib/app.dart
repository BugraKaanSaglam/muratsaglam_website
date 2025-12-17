import 'dart:ui' as ui show TextDirection;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ui/home_page.dart';

/// Root MaterialApp with theming and localization.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1BBDE3),
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Dr. Murat Sağlam',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF6F9FB),
        textTheme: GoogleFonts.manropeTextTheme(),
        useMaterial3: true,
      ),
      // Keep layout left-to-right even for RTL languages; only translated text changes.
      builder: (context, child) => Directionality(
        textDirection: ui.TextDirection.ltr,
        child: child ?? const SizedBox.shrink(),
      ),
      home: const HomePage(),
    );
  }
}
