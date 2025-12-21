import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/service_info.dart';

/// Loads localized service content from bundled assets.
class ContentRepository {
  Future<List<ServiceInfo>> loadServices(Locale locale) async {
    final raw = await _loadContentForLocale(locale);
    final parsed = jsonDecode(raw) as List<dynamic>;
    return parsed
        .map(
          (e) => ServiceInfo.fromJson(
            e as Map<String, dynamic>,
            _imageMap,
          ),
        )
        .toList();
  }

  Future<String> _loadContentForLocale(Locale locale) async {
    final langCode = locale.languageCode.toLowerCase();
    final candidates = <String>[
      'assets/content/pages_$langCode.json',
      if (langCode != 'tr') 'assets/content/pages_en.json',
      'assets/content/pages.json',
    ];

    for (final path in candidates) {
      try {
        return await rootBundle.loadString(path);
      } catch (_) {
        // Try next fallback.
      }
    }

    throw FlutterError('No content asset found for $langCode');
  }
}

const Map<String, String> _imageMap = {
  'okuloplasti-nedir': 'assets/images/msaglam.jpg',
  'vitreoretinal-cerrahi': 'assets/images/retina.jpg',
  'eximer-lazer': 'assets/images/gozdelazer.jpg',
  'iletisim-tr': 'assets/images/footerimg.jpg',
  'goz-kurulugu-tr': 'assets/images/gozkurulugu.jpg',
  'kornea-hastaliklari-tr': 'assets/images/kornea.jpg',
  'retina-hastaliklari-tr': 'assets/images/retina.jpg',
  'goz-tansiyonu-glokom': 'assets/images/goztansiyonu.jpg',
  'katarakt': 'assets/images/katarakt.jpg',
  'gozde-iltihabi-hastaliklar': 'assets/images/iltihap.jpg',
  'sasilik': 'assets/images/sasilik.jpg',
  'gorme-kusurlari': 'assets/images/gormekusurlari.jpg',
  'diger-kapak-sekil-bozukluklari': 'assets/images/msaglam4.jpg',
  'goz-yasi-kanal-hastaliklari-goz-sulanmasi': 'assets/images/gozde_lazer1.jpg',
  'goz-protezi-veya-gozde-tattoo': 'assets/images/msaglam1.jpg',
  'goz-kapagi-sarkmasi-blefaroselazis': 'assets/images/msaglam4.jpg',
  'gozalti-torbalari': 'assets/images/msaglam2.jpg',
  'goz-kapagi-dusuklugu-ptozis': 'assets/images/msaglam4.jpg',
  'murat-saglam-kimdir': 'assets/images/muratsaglamimage.jpg',
};
