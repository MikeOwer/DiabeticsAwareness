import 'package:diabetic_app/controllers/quiz_controller.dart';
import 'package:diabetic_app/pages/quiz_lobby_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../my_classes/auth.dart';

class CongratsCardWidget extends StatelessWidget{

  final User? user = Auth().currentUser;
  QuizController quizController = QuizController.getInstance();
  int level = 0;

  CongratsCardWidget({required this.level});

  Future shareWithFacebook(int level) async {
    final text = '¡He completado con éxito el nivel $level del Quiz de DiabeticAwareness!.';
    await Share.share(text);
    updateProgress();
  }

  void updateProgress() {
    if((quizController.quizProgress.getMaxLevel() == quizController.quizProgress.getHealthyLevels()
    && quizController.quizProgress.getMaxLevel() > this.level)
    || quizController.quizProgress.getMaxLevel() == 0){
      quizController.quizProgress.increaseMaxLevel();
      quizController.quizProgress.increaseHealthyLevels();
    } else if (quizController.quizProgress.getMaxLevel() > quizController.quizProgress.getHealthyLevels()){
      quizController.quizProgress.increaseHealthyLevels();
    }
    quizController.updateProgressJSONFile();
    quizController.resetQuiz();
  }
  void goBackToQuizMenu(BuildContext context){
    updateProgress();
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QuizLobbyPage())
    );
  }

  Widget _facebookButton() {
    return ElevatedButton(
      onPressed: () => shareWithFacebook(this.level),
      child: Text(
          'Compartir mi logro'
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text("¡Felicidades!\n Completaste exitosamente el nivel.",
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40,),
                user != null? _facebookButton() : SizedBox(),
                GestureDetector(
                  onTap: () => goBackToQuizMenu(context),
                  child: Text("Regresar al menú"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}