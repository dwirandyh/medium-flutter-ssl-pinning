import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medium_ssl_pinning/model/article.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:medium_ssl_pinning/service/news_api_service.dart';

Future<SecurityContext> get globalContext async {
  final sslCert = await rootBundle.load('assets/certificate.pem');
  SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
  securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
  return securityContext;
}

Future<http.Client> getSSLPinningClient() async {
  HttpClient client = HttpClient(context: await globalContext);
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => false;
  IOClient ioClient = IOClient(client);
  return ioClient;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final client = await getSSLPinningClient();

  final apiService = NewsApiService(client);

  runApp(MyApp(apiService: apiService));
}

class MyApp extends StatelessWidget {
  final NewsApiService apiService;
  const MyApp({super.key, required this.apiService});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App SSL Pinning',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('News App SSL Pinning'),
        ),
        body: FutureBuilder<List<Article>>(
          future: apiService.fetchArticle(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
            if (snapshot.data != null) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final article = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.title,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(article.description),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data?.length,
              );
            } else {
              return Center(
                child: Column(
                  children: const [
                    CircularProgressIndicator(),
                    Text("Load data, please wait...")
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
