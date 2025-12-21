import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../l10n/keys.dart';
import '../../models/service_info.dart';

/// Hero with CTA and doctor portrait.
class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.heroInfo,
    required this.onContact,
    required this.onServices,
  });

  final ServiceInfo heroInfo;
  final VoidCallback onContact;
  final VoidCallback onServices;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 820;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: isMobile ? 0 : 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.heroBadge.tr(),
                  style: TextStyle(
                    color: const Color(0xFF0EA5E9),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${LocaleKeys.heroTitle.tr()}\nMurat Sağlam',
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.black,
                    fontSize: isMobile ? 34 : 44,
                    height: 1.1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  heroInfo.content,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.8),
                    fontSize: isMobile ? 14 : 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ElevatedButton(
                      onPressed: onContact,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1BBDE3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        LocaleKeys.ctaAppointment.tr(),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: onServices,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(LocaleKeys.ctaServices.tr()),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18, width: 18),
          Expanded(
            flex: isMobile ? 0 : 4,
            child: Align(
              alignment: isMobile ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: isMobile ? double.infinity : 360,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 30,
                      offset: const Offset(0, 24),
                    ),
                  ],
                ),
                child: AspectRatio(
                  aspectRatio: isMobile ? 3 / 4 : 4 / 5,
                  child: Stack(
                    children: [
                      Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.asset(
                          'assets/images/muratsaglamimage.jpg',
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _Pill(text: LocaleKeys.heroPill1.tr()),
                            _Pill(text: LocaleKeys.heroPill2.tr()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
