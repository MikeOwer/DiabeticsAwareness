  import 'dart:convert';

  import 'package:diabetic_app/my_widgets/news_card_widget.dart';
  import 'package:diabetic_app/my_classes/news.dart';
  import 'package:flutter/services.dart';

  class NewsController {

    List<News> news = [];
    List<NewsCard> newsWidgets = [];


    Future<void> readJSONFromFile() async {
      try{
        final String response = await rootBundle.loadString('assets/news_files/news.json');
        final data = await json.decode(response);

        List<dynamic> newsList = data['noticias'];

        for(var newsArticle in newsList) {
          String title = newsArticle['titulo'];
          String image = newsArticle['imagen'];
          String site = newsArticle['sitio'];

          News noticia = News(title: title, imageUrl: image, siteUrl: site);
          news.add(noticia);
        }

      }catch (e){
        print("Exception catch at readJSONFromFile in NewsController: $e");
      }
    }

    List<NewsCard> generateNewsWidgets() {
      try {
        for (int i = 0; i < news.length; i++) {
          newsWidgets.add(NewsCard(newsInfo: news[i]));
        }
      }catch (e) {
        print("Exception catch at generateNewsWidget: $e" );
      }
      return newsWidgets;
    }
  }