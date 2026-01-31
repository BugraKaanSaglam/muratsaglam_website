import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/keys.dart';
import 'reveal.dart';

/// Highlights key expertise and technology in a rich strip.
class ExpertiseStrip extends StatelessWidget {
  const ExpertiseStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 820;
    final items = [
      _ExpertiseItem(
        icon: Icons.remove_red_eye_outlined,
        title: LocaleKeys.expertiseItem1Title.tr(),
        body: LocaleKeys.expertiseItem1Body.tr(),
      ),
      _ExpertiseItem(
        icon: Icons.track_changes_rounded,
        title: LocaleKeys.expertiseItem2Title.tr(),
        body: LocaleKeys.expertiseItem2Body.tr(),
      ),
      _ExpertiseItem(
        icon: Icons.auto_fix_high_rounded,
        title: LocaleKeys.expertiseItem3Title.tr(),
        body: LocaleKeys.expertiseItem3Body.tr(),
      ),
      _ExpertiseItem(
        icon: Icons.visibility_rounded,
        title: LocaleKeys.expertiseItem4Title.tr(),
        body: LocaleKeys.expertiseItem4Body.tr(),
      ),
      _ExpertiseItem(
        icon: Icons.blur_on_rounded,
        title: LocaleKeys.expertiseItem5Title.tr(),
        body: LocaleKeys.expertiseItem5Body.tr(),
      ),
      _ExpertiseItem(
        icon: Icons.lens_rounded,
        title: LocaleKeys.expertiseItem6Title.tr(),
        body: LocaleKeys.expertiseItem6Body.tr(),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFFF8FBFF), Color(0xFFE7F3FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFFDBEAFE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -40,
            child: _Glow(size: 180, color: const Color(0xFFBAE6FD)),
          ),
          Positioned(
            bottom: -70,
            left: -40,
            child: _Glow(size: 200, color: const Color(0xFFBFDBFE)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Reveal(
                child: Text(
                  LocaleKeys.expertiseTitle.tr(),
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Reveal(
                delay: const Duration(milliseconds: 120),
                child: Text(
                  LocaleKeys.expertiseSubtitle.tr(),
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.72),
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  final crossAxisCount = maxWidth > 1200
                      ? 3
                      : maxWidth > 840
                          ? 2
                          : 1;
                  final cardWidth =
                      (maxWidth - (crossAxisCount - 1) * 16) / crossAxisCount;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      for (var i = 0; i < items.length; i++)
                        SizedBox(
                          width: isMobile ? maxWidth : cardWidth,
                          child: Reveal(
                            delay: Duration(milliseconds: 160 + i * 80),
                            child: _ExpertiseCard(item: items[i]),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExpertiseItem {
  const _ExpertiseItem({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}

class _ExpertiseCard extends StatefulWidget {
  const _ExpertiseCard({required this.item});

  final _ExpertiseItem item;

  @override
  State<_ExpertiseCard> createState() => _ExpertiseCardState();
}

class _ExpertiseCardState extends State<_ExpertiseCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 160),
        scale: _hovered ? 1.01 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hovered
                  ? const Color(0xFF93C5FD)
                  : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _hovered ? 0.12 : 0.06),
                blurRadius: _hovered ? 20 : 14,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  widget.item.icon,
                  color: const Color(0xFF0EA5E9),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.title,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.item.body,
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.72),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.25),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 80,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}
