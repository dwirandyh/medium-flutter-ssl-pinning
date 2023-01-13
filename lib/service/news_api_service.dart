import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:medium_ssl_pinning/model/article.dart';
import 'package:medium_ssl_pinning/model/news_response.dart';

class NewsApiService {
  static const apiKey = "788576fa85e0490eacac2d580771d924";
  static const baseUrl = "https://newsapi.org/v2";

  final http.Client client;

  NewsApiService(this.client);

  Future<List<Article>> fetchArticle() async {
    final uri = Uri.parse(
        '$baseUrl/everything?q=flutter&apiKey=788576fa85e0490eacac2d580771d924');
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return NewsResponse.fromJson(json.decode(response.body)).articles;
    } else {
      throw Error();
    }
  }
}
