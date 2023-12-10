import 'package:diabetic_app/controllers/quiz_controller.dart';
import 'package:diabetic_app/pages/quiz_lobby_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../my_classes/auth.dart';

class CongratsCardWidget extends StatelessWidget {
  final User? user = Auth().currentUser;
  QuizController quizController = QuizController.getInstance();
  int level = 0;

  CongratsCardWidget({super.key, required this.level});

  Future shareWithFacebook(int level) async {
    final text =
        '¡He completado con éxito el nivel $level del Quiz de DiabeticAwareness!.';
    await Share.share(text);
    updateProgress();
  }

  void updateProgress() {
    if ((quizController.quizProgress.getMaxLevel() ==
                quizController.quizProgress.getHealthyLevels() &&
            quizController.quizProgress.getMaxLevel() > level) ||
        quizController.quizProgress.getMaxLevel() == 0) {
      quizController.quizProgress.increaseMaxLevel();
      quizController.quizProgress.increaseHealthyLevels();
    } else if (quizController.quizProgress.getMaxLevel() >
        quizController.quizProgress.getHealthyLevels()) {
      quizController.quizProgress.increaseHealthyLevels();
    }
    quizController.updateProgressJSONFile();
    quizController.resetQuiz();
  }

  void goBackToQuizMenu(BuildContext context) {
    updateProgress();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const QuizLobbyPage()));
  }

  Widget _facebookButton() {
    return ElevatedButton(
      onPressed: () => shareWithFacebook(level),
      child: const Text('Compartir mi logro'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(width: 10, color: Color(0xFF002556))),
        child: const Padding(
          padding: EdgeInsets.only(top: 70),
          child: Column(
            children: [
              Text(
                "¡Felicidades!\n Completaste exitosamente el nivel.",
                style: TextStyle(
                  fontSize: 35,
                  color: Color(0xFF002556),
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 60,
                    color: Color(
                        0xFF002556), // Puedes cambiar el color según tus preferencias
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "¡Nivel 2 desbloqueado!",
                    style: TextStyle(
                      fontSize: 35,
                      color: Color(0xFF002556),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
