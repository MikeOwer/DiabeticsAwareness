import 'package:diabetic_app/controllers/quiz_controller.dart';
import 'package:diabetic_app/pages/home_page.dart';
import 'package:diabetic_app/pages/quiz_page.dart';
import 'package:flutter/material.dart';

import '../my_classes/progress.dart';

class QuizLobbyPage extends StatefulWidget {
  const QuizLobbyPage(
      {super.key}); //Fue retirado su uso por especificaciones de los requisitos. Pero se mantiene por si acaso.

  @override
  State createState() => _QuizLobbyPageState();
}

void startQuiz(BuildContext context, int level) {
  if (level == 1) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => QuizPage()));
  } else if (level == 2) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => QuizPage()));
  } else {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => QuizPage()));
  }
}

void returnToMenu(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const HomePage()));
}

ElevatedButton quizLevelButton(BuildContext context, int nivel) {
  QuizController quizController = QuizController.getInstance();
  Progress myProgress = quizController.quizProgress;
  Color getButtonColor() {
    if (myProgress.maxLevel >= nivel && myProgress.healthyLevels >= nivel) {
      // Estado completado
      return Colors.greenAccent; // Color rojo
    } else if (myProgress.healthyLevels < nivel &&
        myProgress.healthyLevels != myProgress.maxLevel) {
      // Estado desatendido
      return Colors.green; // Color gris
    }
    // Estado normal
    return Colors.grey; // Color verde
  }

  return ElevatedButton(
    onPressed: () => startQuiz(context, nivel),
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(getButtonColor()),
    ),
    child: SizedBox(
      width: 150,
      height: 70,
      child: Center(
        child: Text(
          'Nivel $nivel',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    ),
  );
}

Widget _title(String title) {
  return Text(
    title,
    style: const TextStyle(fontSize: 36),
  );
}

class _QuizLobbyPageState extends State<QuizLobbyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          title: _title('Quiz'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 40),
            onPressed: () => returnToMenu(context),
          ),
        ),
        body: GestureDetector(
          child: ListView(
            padding: const EdgeInsets.all(30),
            children: [
              _title('Selecciona un nivel:'),
              const SizedBox(
                height: 80,
              ),
              Container(
                  alignment: Alignment.center,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        quizLevelButton(context, 3),
                        const SizedBox(
                          height: 30,
                        ),
                        quizLevelButton(context, 2),
                        const SizedBox(
                          height: 30,
                        ),
                        quizLevelButton(context, 1),
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }
}
