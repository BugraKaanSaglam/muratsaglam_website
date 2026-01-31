import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/keys.dart';
import 'reveal.dart';

/// Bottom language selector with short descriptions.
class LanguageShowcase extends StatelessWidget {
  const LanguageShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final current = context.locale.languageCode.toLowerCase();
    final items = [
      _LanguageItem(
        locale: const Locale('tr'),
        title: LocaleKeys.languagesTrTitle.tr(),
        body: LocaleKeys.languagesTrBody.tr(),
      ),
      _LanguageItem(
        locale: const Locale('en'),
        title: LocaleKeys.languagesEnTitle.tr(),
        body: LocaleKeys.languagesEnBody.tr(),
      ),
      _LanguageItem(
        locale: const Locale('de'),
        title: LocaleKeys.languagesDeTitle.tr(),
        body: LocaleKeys.languagesDeBody.tr(),
      ),
      _LanguageItem(
        locale: const Locale('ar'),
        title: LocaleKeys.languagesArTitle.tr(),
        body: LocaleKeys.languagesArBody.tr(),
      ),
      _LanguageItem(
        locale: const Locale('fa'),
        title: LocaleKeys.languagesFaTitle.tr(),
        body: LocaleKeys.languagesFaBody.tr(),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Reveal(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.language_rounded,
                    color: Color(0xFF0EA5E9),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  LocaleKeys.languagesTitle.tr(),
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Reveal(
            delay: const Duration(milliseconds: 120),
            child: Text(
              LocaleKeys.languagesSubtitle.tr(),
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.72),
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final crossAxisCount = maxWidth > 1100
                  ? 3
                  : maxWidth > 800
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
                      width: cardWidth,
                      child: Reveal(
                        delay: Duration(milliseconds: 160 + i * 80),
                        child: _LanguageCard(
                          item: items[i],
                          selected:
                              items[i].locale.languageCode.toLowerCase() ==
                                  current,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LanguageItem {
  const _LanguageItem({
    required this.locale,
    required this.title,
    required this.body,
  });

  final Locale locale;
  final String title;
  final String body;
}

class _LanguageCard extends StatefulWidget {
  const _LanguageCard({
    required this.item,
    required this.selected,
  });

  final _LanguageItem item;
  final bool selected;

  @override
  State<_LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<_LanguageCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.selected;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 160),
        scale: _hovered ? 1.01 : 1.0,
        child: GestureDetector(
          onTap: () => context.setLocale(widget.item.locale),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFE0F2FE)
                  : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected || _hovered
                    ? const Color(0xFF7DD3FC)
                    : const Color(0xFFE2E8F0),
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.withValues(alpha: isSelected ? 0.12 : 0.06),
                  blurRadius: isSelected ? 18 : 12,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _FlagBadge(code: widget.item.locale.languageCode),
                    const SizedBox(width: 8),
                    Text(
                      widget.item.title,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          LocaleKeys.languagesSelected.tr(),
                          style: const TextStyle(
                            color: Color(0xFF0EA5E9),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.item.body,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.72),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      LocaleKeys.languagesAction.tr(),
                      style: const TextStyle(
                        color: Color(0xFF0EA5E9),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Color(0xFF0EA5E9),
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FlagBadge extends StatelessWidget {
  const _FlagBadge({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    switch (code.toLowerCase()) {
      case 'tr':
        return _TurkeyFlag();
      case 'de':
        return _StripeFlag(
          colors: [Colors.black, const Color(0xFFDD1C1A), const Color(0xFFFFD166)],
        );
      case 'ar':
        return _StripeFlag(
          colors: [const Color(0xFF16A34A), Colors.white, Colors.black],
        );
      case 'fa':
        return _StripeFlag(
          colors: [const Color(0xFF16A34A), Colors.white, const Color(0xFFDC2626)],
        );
      default:
        return _UsaFlag();
    }
  }
}

class _StripeFlag extends StatelessWidget {
  const _StripeFlag({required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return _FlagBase(
      child: Column(
        children: colors
            .map(
              (color) => Expanded(
                child: Container(color: color),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TurkeyFlag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _FlagBase(
      color: const Color(0xFFE11D48),
      child: Stack(
        children: const [
          Positioned(
            left: 6,
            top: 4,
            child: _Circle(color: Colors.white, size: 8),
          ),
          Positioned(
            left: 8,
            top: 5,
            child: _Circle(color: Color(0xFFE11D48), size: 6),
          ),
          Positioned(
            left: 14,
            top: 5,
            child: Icon(Icons.star, size: 6, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _UsaFlag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _FlagBase(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(child: Container(color: const Color(0xFFB91C1C))),
              Expanded(child: Container(color: Colors.white)),
              Expanded(child: Container(color: const Color(0xFFB91C1C))),
              Expanded(child: Container(color: Colors.white)),
              Expanded(child: Container(color: const Color(0xFFB91C1C))),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 12,
              height: 9,
              color: const Color(0xFF1D4ED8),
            ),
          ),
        ],
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _FlagBase extends StatelessWidget {
  const _FlagBase({required this.child, this.color});

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 18,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
