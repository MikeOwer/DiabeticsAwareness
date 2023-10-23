import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:diabetic_app/my_classes/news.dart';

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchURL,
      child: Container(
        width: 350, // Ancho deseado del card
        height: 400,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Card(
          color: Colors.grey[300],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10,),
              ListTile(
                title: Text(
                  newsInfo.title,
                  textScaleFactor: 1.5,
                ),
              ),
              SizedBox(height: 10,),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    newsInfo.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}