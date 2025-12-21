import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../l10n/keys.dart';

/// Three quick highlight cards.
class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 720;
    final items = [
      (LocaleKeys.stat1Title.tr(), LocaleKeys.stat1Body.tr()),
      (LocaleKeys.stat2Title.tr(), LocaleKeys.stat2Body.tr()),
      (LocaleKeys.stat3Title.tr(), LocaleKeys.stat3Body.tr()),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        return Wrap(
          spacing: 16,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: items
              .map(
                (item) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  constraints: BoxConstraints(
                    minWidth: isMobile ? maxWidth : 260,
                    maxWidth: isMobile ? maxWidth : 340,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.$1,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.$2,
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.75),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
