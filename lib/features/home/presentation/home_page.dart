import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/l10n/keys.dart';
import '../data/content_repository.dart';
import '../models/service_info.dart';
import 'widgets/about_section.dart';
import 'widgets/contact_section.dart';
import 'widgets/expertise_strip.dart';
import 'widgets/featured_service.dart';
import 'widgets/hero_section.dart';
import 'widgets/language_showcase.dart';
import 'widgets/nav_bar.dart';
import 'widgets/service_dialog.dart';
import 'widgets/services_grid.dart';
import 'widgets/stats_row.dart';

/// Home page orchestrates sections and data loading.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _prosthesisSlug = 'goz-protezi-veya-gozde-tattoo';

  late final ScrollController _scrollController;
  final ContentRepository _contentRepository = ContentRepository();
  Future<List<ServiceInfo>>? _servicesFuture;
  Locale? _loadedLocale;

  final _heroKey = GlobalKey();
  final _servicesKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = context.locale;
    if (_loadedLocale != locale) {
      _loadedLocale = locale;
      _servicesFuture = _contentRepository.loadServices(locale);
      setState(() {});
    }
  }

  ServiceInfo _placeholderService(String slug) {
    return ServiceInfo(
      title: '',
      slug: slug,
      excerpt: '',
      content: '',
      image: 'assets/images/msaglam.jpg',
    );
  }

  ServiceInfo _findService(
    List<ServiceInfo> services,
    String slug, {
    ServiceInfo? fallback,
  }) {
    return services.firstWhere(
      (e) => e.slug == slug,
      orElse: () {
        debugPrint('Missing service content for slug: $slug');
        return fallback ?? _placeholderService(slug);
      },
    );
  }

  ServiceInfo? _findOptionalService(List<ServiceInfo> services, String slug) {
    for (final service in services) {
      if (service.slug == slug) {
        return service;
      }
    }
    return null;
  }

  void _scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _openAppointment() async {
    final booking = Uri.parse(
      'https://www.doktortakvimi.com/murat-saglam/goz-hastaliklari/ordu',
    );
    if (await canLaunchUrl(booking)) {
      await launchUrl(booking, mode: LaunchMode.externalApplication);
      return;
    }
    final tel = Uri(scheme: 'tel', path: '+904528001818');
    if (await canLaunchUrl(tel)) {
      await launchUrl(tel);
    }
  }

  @override
  Widget build(BuildContext context) {
    final servicesFuture = _servicesFuture;
    if (servicesFuture == null) {
      return const _LoadingScreen();
    }

    return FutureBuilder<List<ServiceInfo>>(
      future: servicesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint(
            'Services load failed: ${snapshot.error}\n${snapshot.stackTrace}',
          );
          return _ErrorScreen(
            message: snapshot.error.toString(),
            onRetry: _retryLoad,
          );
        }
        if (snapshot.connectionState != ConnectionState.done ||
            !snapshot.hasData) {
          return const _LoadingScreen();
        }
        final services = snapshot.data!;
        final about = _findService(services, 'murat-saglam-kimdir');
        final contact = _findService(
          services,
          'iletisim-tr',
          fallback: ServiceInfo(
            title: LocaleKeys.navContact.tr(),
            slug: 'iletisim-tr',
            excerpt: '',
            content: '',
            image: 'assets/images/footerimg.jpg',
          ),
        );
        final heroInfo = _findService(services, 'okuloplasti-nedir');
        final prosthesis =
            _findOptionalService(services, _prosthesisSlug);
        final serviceItems = services
            .where((e) =>
                e.slug != 'iletisim-tr' && e.slug != 'murat-saglam-kimdir')
            .toList();
        final orderedServices = [
          ...serviceItems.where((e) => e.slug == _prosthesisSlug),
          ...serviceItems.where((e) => e.slug != _prosthesisSlug),
        ];

        return Scaffold(
          body: Stack(
            children: [
              const _Backdrop(),
              SafeArea(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      NavBar(
                        onHome: () => _scrollTo(_heroKey),
                        onServices: () => _scrollTo(_servicesKey),
                        onAbout: () => _scrollTo(_aboutKey),
                        onContact: () => _scrollTo(_contactKey),
                        onAppointment: _openAppointment,
                      ),
                      const SizedBox(height: 14),
                      HeroSection(
                        key: _heroKey,
                        heroInfo: heroInfo,
                        onContact: () => _scrollTo(_contactKey),
                        onServices: () => _scrollTo(_servicesKey),
                      ),
                      if (prosthesis != null) ...[
                        const SizedBox(height: 22),
                        FeaturedService(
                          info: prosthesis,
                          onOpen: () => _openDetails(context, prosthesis),
                          onAppointment: _openAppointment,
                        ),
                      ],
                      const SizedBox(height: 28),
                      const StatsRow(),
                      const SizedBox(height: 24),
                      const ExpertiseStrip(),
                      const SizedBox(height: 28),
                      ServicesGrid(
                        key: _servicesKey,
                        services: orderedServices,
                        featuredSlug: _prosthesisSlug,
                        onOpen: (info) => _openDetails(context, info),
                      ),
                      const SizedBox(height: 28),
                      AboutSection(key: _aboutKey, about: about),
                      const SizedBox(height: 28),
                      ContactSection(
                        key: _contactKey,
                        contact: contact,
                        onAppointment: _openAppointment,
                      ),
                      const SizedBox(height: 28),
                      const LanguageShowcase(),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _retryLoad() {
    _servicesFuture = _contentRepository.loadServices(context.locale);
    setState(() {});
  }

  void _openDetails(BuildContext context, ServiceInfo info) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'details',
      barrierColor: Colors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (_, __, ___) => Center(
        child: ServiceDialog(info: info),
      ),
      transitionBuilder: (_, anim, __, child) {
        return Transform.scale(
          scale: Curves.easeOutCubic.transform(anim.value),
          child: Opacity(opacity: anim.value, child: child),
        );
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _Backdrop(),
          Center(
            child: _LoadingCard(),
          ),
        ],
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _Backdrop(),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.commonLoadError.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.75),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1BBDE3),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(LocaleKeys.commonRetry.tr()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 18),
          ),
        ],
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${LocaleKeys.heroTitle.tr()} Murat Sağlam',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: isMobile ? 16 : 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const SizedBox(
            width: 46,
            height: 46,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: Color(0xFF1BBDE3),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            LocaleKeys.commonLoading.tr(),
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
              fontSize: isMobile ? 13 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _Backdrop extends StatelessWidget {
  const _Backdrop();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF6F9FB),
                  Color(0xFFE8F5FF),
                  Color(0xFFDFF3F6)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: -100,
            left: -80,
            child: _BlurCircle(
              color: const Color(0xFF8EE0FF),
              size: 260,
              opacity: 0.38,
            ),
          ),
          Positioned(
            bottom: -160,
            right: -40,
            child: _BlurCircle(
              color: const Color(0xFFA5F3FC),
              size: 240,
              opacity: 0.35,
            ),
          ),
          Positioned(
            top: 420,
            right: 120,
            child: _BlurCircle(
              color: const Color(0xFF9AE6B4),
              size: 220,
              opacity: 0.28,
            ),
          ),
        ],
      ),
    );
  }
}

class _BlurCircle extends StatelessWidget {
  const _BlurCircle({
    required this.color,
    required this.size,
    required this.opacity,
  });

  final Color color;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final tint = color.withValues(alpha: opacity);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: tint,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: tint.withValues(alpha: 0.4),
            blurRadius: 120,
            spreadRadius: 60,
          ),
        ],
      ),
    );
  }
}
