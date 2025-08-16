class Article {
  final String title;
  final String description;
  final String url;
  final String? urlToImage;
  final String publishedAt; // ISO 8601 string
  final String? source;
  final String? author;

  Article({
    required this.title,
    required this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.source,
    this.author,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      url: (json['url'] ?? '').toString(),
      urlToImage: json['urlToImage']?.toString(),
      publishedAt: (json['publishedAt'] ?? '').toString(),
      source: json['source'] is Map && json['source']['name'] != null
          ? json['source']['name'].toString()
          : null,
      author: json['author']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'url': url,
    'urlToImage': urlToImage,
    'publishedAt': publishedAt,
    'source': source,
    'author': author,
  };
}