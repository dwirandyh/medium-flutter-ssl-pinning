import 'dart:convert';

import 'package:medium_ssl_pinning/model/article.dart';

class NewsResponse {
  NewsResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  final String? status;
  final int? totalResults;
  final List<Article> articles;

  factory NewsResponse.fromRawJson(String str) =>
      NewsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NewsResponse.fromJson(Map<String, dynamic> json) => NewsResponse(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: json["articles"] == null
            ? []
            : List<Article>.from(
                json["articles"].map((x) => Article.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "totalResults": totalResults,
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
      };
}
