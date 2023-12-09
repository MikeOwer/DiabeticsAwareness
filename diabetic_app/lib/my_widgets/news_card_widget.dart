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

  const NewsCard({super.key, required this.newsInfo});

  void _launchURL() async {
    if (await canLaunch(newsInfo.siteUrl)) {
      await launch(newsInfo.siteUrl);
    } else {
      throw 'No se pudo abrir ${newsInfo.siteUrl}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Ancho deseado del card
      height: 170,
      //padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Card(
        color: Colors.white, //Color de fondo de las tarjetas
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(width: 6, color: const Color(0xFF002556))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              width: 15,
            ),
            SizedBox(
              width: 120, // Ancho deseado del card
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  newsInfo.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 120.0, // Establece la altura deseada
                    child: ListTile(
                      title: Text(
                        newsInfo.title,
                        maxLines:
                            3, // Define el número máximo de líneas que se mostrarán
                        overflow:
                            TextOverflow.ellipsis, // Agrega puntos suspensivos
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.5,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                  const Row(
                    //el lenguaje pide ponerle const
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Más información",
                        style: TextStyle(
                          color: Color(0xFF002556),
                          fontFamily: 'Montserrat-SemiBold.ttf',
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF002556),
                      ),
                      SizedBox(
                        width: 5,
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
      ),
    );
  }
}

/*class QuizCard extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  QuizCard({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: onPressed,
              child: Text('Presionar'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
