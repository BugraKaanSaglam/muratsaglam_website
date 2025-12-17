/// Basic model for a service/article section.
class ServiceInfo {
  final String title;
  final String slug;
  final String excerpt;
  final String content;
  final String image;

  ServiceInfo({
    required this.title,
    required this.slug,
    required this.excerpt,
    required this.content,
    required this.image,
  });

  factory ServiceInfo.fromJson(
    Map<String, dynamic> json,
    Map<String, String> imageMap,
  ) {
    final slug = json['slug'] as String;
    return ServiceInfo(
      title: json['title'] as String,
      slug: slug,
      excerpt: json['excerpt'] as String? ?? '',
      content: json['content'] as String? ?? '',
      image: imageMap[slug] ?? 'assets/images/msaglam.jpg',
    );
  }
}
