import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';
import '../services/news_service.dart';

enum LoadState { idle, loading, error }

class ArticlesProvider extends ChangeNotifier {
  final _service = NewsService();
  final List<Article> _articles = [];
  List<Article> get articles => List.unmodifiable(_articles);

  LoadState _state = LoadState.idle;
  LoadState get state => _state;

  String? _error;
  String? get error => _error;

  String _query = '';
  String get query => _query;

  List<Article> get filtered {
    if (_query.trim().isEmpty) return articles;
    final q = _query.toLowerCase();
    return _articles.where((a) =>
    a.title.toLowerCase().contains(q) ||
        a.description.toLowerCase().contains(q) ||
        (a.source ?? '').toLowerCase().contains(q)).toList();
  }

  Future<void> bootstrap() async {
    await Future.delayed(const Duration(milliseconds: 200));
    await refresh();
  }

  Future<void> refresh() async {
    _state = LoadState.loading;
    _error = null;
    notifyListeners();

    try {
      final list = await _service.fetchTopHeadlines(country: 'in', pageSize: 50);
      if (list.isNotEmpty) {
        _articles
          ..clear()
          ..addAll(list);
        await _saveCache(list);
        _state = LoadState.idle;
      } else {
        _state = LoadState.error;
        _error = 'No articles found from API.';
      }
    } catch (e) {
      final cached = await _loadCache();
      if (cached.isNotEmpty) {
        _articles
          ..clear()
          ..addAll(cached);
        _state = LoadState.idle;
        _error = 'Showing cached articles (offline).';
      } else {
        _state = LoadState.error;
        _error = e.toString();
      }
    }

    if (kDebugMode) {
      print('State: $_state, error: $_error, articles: ${_articles.length}');
    }

    notifyListeners();
  }

  Future<void> searchText(String q) async {
    _query = q;
    notifyListeners();
  }

  Future<void> _saveCache(List<Article> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.setString('cached_articles', jsonList);
    await prefs.setString('cached_at', DateTime.now().toIso8601String());
  }

  Future<List<Article>> _loadCache() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString('cached_articles');
    if (str == null) return [];
    try {
      final List data = jsonDecode(str);
      return data.map((e) => Article.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }
}