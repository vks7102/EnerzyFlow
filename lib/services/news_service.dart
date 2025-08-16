import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  static const String apiKey = '7d98d3c750a541968453c438567faa0e';
  static const String baseUrl = 'https://newsapi.org/v2';

  Future<List<Article>> fetchTopHeadlines({String country = 'us', int pageSize = 30}) async {
    final uri = Uri.parse('$baseUrl/top-headlines?country=us&pageSize=$pageSize&apiKey=$apiKey');
    if (kDebugMode) print('GET $uri');

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch news: ${res.statusCode}');
    }

    final data = jsonDecode(res.body);
    if (kDebugMode) print('Response status: ${data['status']}, count: ${(data['articles'] ?? []).length}');

    if (data['status'] != 'ok') {
      throw Exception('API error: ${data['message'] ?? 'unknown'}');
    }

    final List items = data['articles'] ?? [];
    return items.map((e) => Article.fromJson(e)).toList();
  }

  Future<List<Article>> search(String query, {int pageSize = 50}) async {
    final uri = Uri.parse('$baseUrl/everything?q=$query&sortBy=publishedAt&language=en&pageSize=$pageSize&apiKey=$apiKey');
    if (kDebugMode) print('GET $uri');

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Failed to search news: ${res.statusCode}');
    }

    final data = jsonDecode(res.body);
    if (data['status'] != 'ok') {
      throw Exception('API error: ${data['message'] ?? 'unknown'}');
    }

    final List items = data['articles'] ?? [];
    return items.map((e) => Article.fromJson(e)).toList();
  }
}