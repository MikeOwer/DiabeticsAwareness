import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diabetic_app/my_classes/auth.dart';
import 'package:diabetic_app/my_widgets/news_card_widget.dart';
import 'package:diabetic_app/controllers/news_controller.dart';
import 'package:diabetic_app/my_widgets/menu_button_widget.dart';
import 'package:diabetic_app/controllers/quiz_controller.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Auth().currentUser;
  List<NewsCard> news = [];
  NewsController newsController = NewsController();
  QuizController quizController = QuizController.getInstance();
  bool noticeVisible = true;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text(
      'Diabetic App',
      style: TextStyle(fontSize: 26),
    ); //DEBE MODIFICARSE CUANDO SE TENGA UN NOMBRE MÁS ADECUADO
  }

  List<Widget> _buildNewsList() {
    List<Widget> widgets = [];
    for (int i = 0; i < news.length; i++) {
      widgets.add(news[i]);
      if (i != news.length - 1) {
        widgets.add(SizedBox(
          height: 20,
        ));
      }
    }
    return widgets;
  }

  @override
  void initState() {
    super.initState();
    loadNews();
    loadProgress();
    //updateLoginRegistry();
  }

  Future<void> loadProgress() async {
    await quizController.readProgressJSONFile();
  }

  Future<void> loadNews() async {
    await newsController.readJSONFromFile();
    setState(() {
      news = newsController.generateNewsWidgets();
    });
  }

  Future<void> updateLoginRegistry() async {
    await quizController.updateProgressJSONFile();
  }

  void _closeNoticeWidget() {
    setState(() {
      noticeVisible = false;
    });
  }

  Widget _noticeWidget() {
    bool logedIn = (user != null);
    return Center(
      child: Card(
        color: Colors.white54,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                logedIn
                    ? '¡Bienvenido de vuelta!'
                    : 'No ha iniciado sesión o su sesión ha expirado.',
                style: TextStyle(fontSize: 20),
              ),
              TextButton(
                onPressed: _closeNoticeWidget,
                child: Text(
                  'Cerrar',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: MenuButtonWidget(),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Text(
            '¿Sabías qué?',
            style: TextStyle(
              fontSize: 26,
            ),
          ),
          if (noticeVisible) _noticeWidget(),
          SizedBox(height: 20),
          // Add the newsWidgets using addAll
          ..._buildNewsList(),
        ],
      ),
    );
  }
}
