import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../l10n/keys.dart';
import '../../models/service_info.dart';

/// Contact block with CTA.
class ContactSection extends StatelessWidget {
  const ContactSection({
    super.key,
    required this.contact,
    required this.onAppointment,
  });

  final ServiceInfo contact;
  final VoidCallback onAppointment;

  @override
  Widget build(BuildContext context) {
    const address = 'Bahçelievler Mah. Atatürk Bulvarı No:207, Altınordu – ORDU';
    const email = 'gozdelazer@gmail.com';
    const phone = '(+90) 452 800 18 18';
    const hours = [
      'Pazartesi - Cumartesi 09:00 – 17:00',
      'Pazar kapalı',
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        image: const DecorationImage(
          image: AssetImage('assets/images/footerimg.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.white70,
            BlendMode.lighten,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.navContact.tr(),
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            contact.content,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _contactCard(LocaleKeys.contactAddress.tr(), address),
              _contactCard(LocaleKeys.contactPhone.tr(), phone),
              _contactCard(LocaleKeys.contactEmail.tr(), email),
              _contactCard(LocaleKeys.contactHours.tr(), hours.join(' · ')),
            ],
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: onAppointment,
            icon: const Icon(Icons.schedule_rounded),
            label: Text(
              LocaleKeys.ctaAppointment.tr(),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0EA5E9),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF0EA5E9),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          SelectableText(
            value,
            style: const TextStyle(
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
