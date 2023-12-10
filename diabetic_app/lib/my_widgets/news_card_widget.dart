import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:diabetic_app/my_classes/news.dart';
import 'package:diabetic_app/ProyectColors.dart';

/*void main() {
  runApp(MyApp());
}*/

/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsPage(),
    );
  }
}*/

/*class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: Center(
        child: NewsCard(
          title: 'Diabetes Tipo 1',
          imageUrl: 'https://medlineplus.gov/images/DiabetesType1.jpg',
          websiteUrl: 'https://medlineplus.gov/spanish/diabetestype1.html',
        ),
      ),
    );
  }
}*/

class NewsCard extends StatelessWidget {
  final News newsInfo;

  /*final String title;
  final String imageUrl;
  final String websiteUrl;*/

  NewsCard({required this.newsInfo});

  void _launchURL() async {
    if (await canLaunch(newsInfo.siteUrl)) {
      await launch(newsInfo.siteUrl);
    } else {
      throw 'No se pudo abrir ${newsInfo.siteUrl}';
    }
  }

  Future<void> _launchUrl() async {
    Uri url = Uri.parse(newsInfo.siteUrl);
    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchUrl();
      },
      child: Container(
        width: 350, // Ancho deseado del card
        height: 200,
        //padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Card(
          color: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side:
                  BorderSide(width: 2, color: Theme.of(context).primaryColor)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 10,
              ),
              Container(
                width: 100, // Ancho deseado del card
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    newsInfo.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: ListTile(
                  title: Text(
                    newsInfo.title,
                    textScaleFactor: 1.5,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
