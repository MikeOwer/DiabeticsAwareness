import 'package:diabetic_app/controllers/quiz_controller.dart';
import 'package:diabetic_app/pages/quiz_page.dart';
import 'package:flutter/material.dart';

class CongratsQuizPage extends StatefulWidget {
  const CongratsQuizPage({super.key});

  @override
  State<CongratsQuizPage> createState() => _CongratsQuizPageState();
}

class _CongratsQuizPageState extends State<CongratsQuizPage> {
  QuizController quizController = QuizController.getInstance();

  @override
  void initState() {
    super.initState();
    updateProgress();
  }

  @override
  Widget build(BuildContext context) {
    //Pagina creada para celebrar el subir de nivel en el quiz
    return Container(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QuizPage())); //Borrar lo del nivel
        },
        child: Text('Pasar al siguiente nivel'),
      ),
    );
  }

  void updateProgress() {
    quizController.quizProgress.increaseMaxLevel();
    quizController.resetQuiz();
    quizController.updateProgressJSONFile();
  }
}
