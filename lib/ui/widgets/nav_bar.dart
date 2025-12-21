import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../l10n/keys.dart';

/// Top navigation with locale switcher.
class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.onHome,
    required this.onServices,
    required this.onAbout,
    required this.onContact,
    required this.onAppointment,
  });

  final VoidCallback onHome;
  final VoidCallback onServices;
  final VoidCallback onAbout;
  final VoidCallback onContact;
  final VoidCallback onAppointment;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 720;
    final navActions = [onHome, onServices, onAbout, onContact];
    final navButtons = [
      _NavButton(label: LocaleKeys.navHome.tr(), onTap: navActions[0]),
      _NavButton(label: LocaleKeys.navServices.tr(), onTap: navActions[1]),
      _NavButton(label: LocaleKeys.navAbout.tr(), onTap: navActions[2]),
      _NavButton(label: LocaleKeys.navContact.tr(), onTap: navActions[3]),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/cropped-msaglamlogo.png',
                  width: 42,
                  height: 42,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${LocaleKeys.heroTitle.tr()}\nMurat Sağlam',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (!isMobile)
            Row(
              children: [
                ...navButtons,
                const SizedBox(width: 10),
                _LocaleSwitcher(),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1BBDE3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: onAppointment,
                  child: Text(
                    LocaleKeys.ctaAppointment.tr(),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                const _LocaleSwitcher(),
                PopupMenuButton<int>(
                  icon: const Icon(Icons.menu_rounded, color: Colors.black87),
                  onSelected: (value) {
                    if (value < navActions.length) {
                      navActions[value]();
                      return;
                    }
                    if (value == navActions.length) {
                      onAppointment();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 0,
                      child: Text(LocaleKeys.navHome.tr()),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: Text(LocaleKeys.navServices.tr()),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Text(LocaleKeys.navAbout.tr()),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: Text(LocaleKeys.navContact.tr()),
                    ),
                    PopupMenuItem(
                      value: 4,
                      child: Text(LocaleKeys.ctaAppointment.tr()),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _LocaleSwitcher extends StatelessWidget {
  const _LocaleSwitcher();

  @override
  Widget build(BuildContext context) {
    final locales = context.supportedLocales;
    return DropdownButtonHideUnderline(
      child: DropdownButton<Locale>(
        value: context.locale,
        icon: const Icon(Icons.language_rounded),
        items: locales
            .map(
              (locale) => DropdownMenuItem(
                value: locale,
                child: Text(locale.languageCode.toUpperCase()),
              ),
            )
            .toList(),
        onChanged: (locale) async {
          if (locale != null) {
            await context.setLocale(locale);
          }
        },
      ),
    );
  }
}
