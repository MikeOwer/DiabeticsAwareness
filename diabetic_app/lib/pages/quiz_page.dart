import 'dart:async';
import 'dart:math';

import 'package:diabetic_app/my_classes/quiz_question.dart';
import 'package:diabetic_app/my_widgets/question_card_widget.dart';
import 'package:diabetic_app/my_widgets/quiz_option_widget.dart';
import 'package:diabetic_app/my_widgets/congrats_card_widget.dart';
import 'package:diabetic_app/pages/congrats_quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:diabetic_app/controllers/quiz_controller.dart';

class QuizPage extends StatefulWidget {
  //int level = 0;

  @override
  _QuizPageState createState() => _QuizPageState();

  QuizPage();
}

class _QuizPageState extends State<QuizPage> {
  int level = 0;
  QuizController quizController = QuizController.getInstance();
  QuizQuestion pickedQuestion = QuizQuestion.empty();
  List<QuizOptionWidget> optionButtons = [];
  late StreamController<int> _stageController;

  int currentStage = 0;

  bool gameStarted = false;
  bool showCard = false;
  bool correctSelected = false;
  bool incorrectSelected = false;

  _QuizPageState(); //Quitar el pedir niveles

  @override
  void initState() {
    super.initState();
    _stageController = StreamController<int>();
    this.level =
        quizController.quizProgress.getMaxLevel(); //Se obtiene el nivel actual
    this.currentStage = quizController.quizProgress
        .getCurrentQuestion(); //Se obtiene el número de la pregunta actual

    _stageController.stream.listen((stage) {
      //Si cambia el stage a 5 se va a la otra pantalla
      if (stage == 5 && quizController.quizProgress.getMaxLevel() < 1) {
        //Limitación temporal de nivel 2
        completeLevel();
      }
    });
    print('Nivel: ${level}'); //Prueba del nivel
    print('currentStage: ${currentStage}'); //Prueba de la pregunta
    loadQuiz(level);
  }

  void loadQuiz(int level) async {
    await quizController.readJSONFromFile(level); //Lee el JSON de las preguntas
    //questions = quizController.selectQuizQuestions(3);
    setState(() {
      gameStarted = true;
      pickQuestion();
    });
  }

  void pickQuestion() {
    try {
      pickedQuestion = quizController.selectQuizQuestion();
      optionButtons = buildOptionButtons(
          pickedQuestion.correctOpt, pickedQuestion.incorrectOpts);
    } catch (e) {
      print('Exception on pickQuestion: $e');
    }
  }

  List<QuizOptionWidget> buildOptionButtons(
      String correctOpt, List<String> incorrectOpts) {
    List<QuizOptionWidget> options = [];

    //Crear botón de la opción correcta
    options.add(QuizOptionWidget(
        text: correctOpt,
        isCorrect: true,
        onTapFn: () => optionSelected(true)));

    //Crear botones de las opciones incorrectas
    for (int i = 0; i < incorrectOpts.length; i++) {
      options.add(QuizOptionWidget(
          text: incorrectOpts[i],
          isCorrect: false,
          onTapFn: () => optionSelected(false)));
    }

    return options;
  }

  void _toggleCardVisibility() {
    setState(() {
      showCard = !showCard;
    });
  }

  void optionSelected(bool isCorrect) {
    Future.delayed(const Duration(milliseconds: 600), () {
      _toggleCardVisibility();
      if (isCorrect) {
        //Ejecución de la opción correcta
        setState(() {
          correctSelected = true;
        });
        Future.delayed(const Duration(milliseconds: 2000), () {
          setState(() {
            correctSelected = false;
            quizController.increaseStage();
            currentStage = quizController
                .getStage(); //Para que haga match con el stage del controller
            _stageController.add(
                currentStage); //Para avisar que cuando llegue a 5 cambie de nivel
          });
          pickQuestion();
        });
      } else {
        //Ejecución de la opción incorrecta
        setState(() {
          incorrectSelected = true;
        });
        Future.delayed(const Duration(milliseconds: 2000), () {
          setState(() {
            incorrectSelected = false;
          });
          quizController.returnQuestion(pickedQuestion);
          pickQuestion();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          //centerTitle: true,
          title: Text(
            'Nivel ${level + 1}',
            style: TextStyle(fontSize: 30),
          ),
          automaticallyImplyLeading: false,
          // Agregar tu propio botón de retroceso
          actions: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                // Navegar hacia atrás
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
        body: _quizBackgroundLayout(),
        backgroundColor: Color(0xFF002556),
      ),
    );
  }

  Widget _correctGIF() {
    return const Center(
        child: Image(image: AssetImage("assets/images/correcto.gif")));
  }

  Widget _incorrectGIF() {
    return const Center(
      child: Image(image: AssetImage("assets/images/sigue_intentando.gif")),
    );
  }

  Widget _quizBackgroundLayout() {
    return Stack(
      //Trabaja como un espacio para acomodar widgets
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/textures/FondoArboles.png',
            fit: BoxFit.cover, //Para rellenar todo el fondo de la actividad
          ),
        ),
        Positioned(
          left: 125,
          right: 125,
          bottom: 0,
          top: 0,
          child: Image.asset(
            'assets/textures/Textura_arbol2.jpg',
            fit: BoxFit.fitHeight,
          ),
        ),
        Positioned(
          left: 125,
          right: 125,
          bottom: 0,
          top: 0,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildListaDeBotones().reversed.toList(),
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: Column(
            children: buildTolokList().reversed.toList(),
          ),
        ),
        /*Positioned(
          right: 60,
          bottom: 0,
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Image.asset('assets/images/Iguana.png')),
        ),*/
        if (showCard && quizController.getStage() < 5)
          QuestionCardWidget(pickedQuestion.question, optionButtons),
        if (correctSelected) _correctGIF(),
        if (incorrectSelected) _incorrectGIF(),
      ],
    );
  }

  void completeLevel() {
    currentStage = 0;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CongratsQuizPage()));
  }

  List<Widget> buildTolokList() {
    List<Widget> tolokList = [];

    for (int i = 0; i < 5; i++) {
      //Modificar lo del tolok
      tolokList.add(
        Container(
          //color: Colors.red,
          child: SizedBox(
            width: 160,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.185,
              //decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              alignment: Alignment.centerLeft,
              child: quizController.quizProgress.currentQuestion == i
                  ? Image.asset('assets/images/Tolok.png')
                  : null,
            ),
          ),
        ),
      );
    }

    return tolokList;
  }

  List<Widget> _buildListaDeBotones() {
    List<Widget> buttonList = [];
    //List<QuizQuestion> questionList = quizController.getLevelQuestionsCopy();

    buttonList.add(
      _buildPrimerElemento(),
    );

    for (int i = 1; i < 5; i++) {
      buttonList.add(
        Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  backgroundColor: setButtonColor(
                      quizController.quizProgress.currentQuestion,
                      i), //Cambio de los colores a blanco
                  disabledBackgroundColor: Colors.white,
                ),
                //Se desabilita el widget si el botón es mayor a la pregunta actual
                onPressed: i > quizController.quizProgress.currentQuestion
                    ? null
                    : () => _toggleCardVisibility(),
                child: setTextButton(
                    quizController.quizProgress.currentQuestion, i),
              ),
            ),
            Container(
              color: setButtonColor(
                  quizController.quizProgress.currentQuestion, i),
              height: MediaQuery.of(context).size.height * 0.12,
              width: 15,
            ),
          ],
        ),
      );
    }
    return buttonList;
  }

  Widget _buildPrimerElemento() {
    return Container(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.06,
        width: 200,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF002556),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          onPressed: () {
            _toggleCardVisibility();
          },
          child: const Text(
            'Pregunta 1',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Color setButtonColor(int numQuestion, int numButton) {
    if (numButton <= numQuestion) {
      return Theme.of(context).primaryColor;
    }
    return Colors.white;
  }

  Text setTextButton(int numQuestion, int numButton) {
    if (numButton <= numQuestion) {
      return Text('Pregunta ${numButton + 1}',
          style: TextStyle(fontSize: 24, color: Colors.white));
    }
    return Text('Pregunta ${numButton + 1}',
        style: TextStyle(fontSize: 24, color: Colors.black));
  }
}
