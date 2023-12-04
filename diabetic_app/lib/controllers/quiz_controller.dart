import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:diabetic_app/my_classes/quiz_question.dart';
import 'package:flutter/services.dart';
import 'package:diabetic_app/my_classes/progress.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class QuizController {
  static QuizController? _instance;
  List<String> questions = [];
  List<String> correctOpts = [];
  List<List<String>> incorrectOpts = [];
  List<QuizQuestion> levelQuestions = [];
  List<QuizQuestion> levelQuestionsCopy = [];
  String questionsPath = 'assets/question_files/preguntas.json';
  Progress quizProgress = Progress();

  int stage = 0;

  QuizController._();

  static QuizController getInstance() {
    if (_instance == null) {
      _instance = QuizController._();
    }
    return _instance!;
  }

  void increaseStage() {
    //Se inncrementa el número de pregunta actual al responder bien una
    if (quizProgress.getMaxLevel() < 2) {
      // Limitando los primeros dos niveles
      if (stage < 6) {
        //Uno más para detectar un cambio del nivel
        this.stage++;
        this.quizProgress.increaseCurrentQuestion();
        updateProgressJSONFile(); //Y sobreescribiendo el progreso
      }
    } else {
      this.stage++;
      this.quizProgress.increaseCurrentQuestion();
      updateProgressJSONFile();
    }
  }

  int getStage() {
    return stage;
  }

  void resetQuiz() {
    this.stage = 0;
    this.quizProgress.currentQuestion = 0;
    updateProgressJSONFile(); //Se reinicia a 0 el número de pregunta actual cuando pasa de nivel
  }

  List<QuizQuestion> getLevelQuestionsCopy() {
    //Getter de la lista de preguntas
    return levelQuestionsCopy;
  }

  Future<void> readJSONFromFile(int level) async {
    try {
      final String response = await rootBundle.loadString(questionsPath);
      final data = await json.decode(response);

      List<dynamic> nivelesList = data['niveles']; //Lee los niveles diponibles
      List<dynamic> questionsList =
          nivelesList[level] //Moví el -1 ----- cambio momentaneo
              ['preguntas']; //Accede a las preguntas del nivel solicitado
      for (var question in questionsList) {
        questions.add(question['texto']); //Se añaden las preguntas
        correctOpts.add(question['respuestas']
            ['correcta']); //Se añade las respuestas correctas
        incorrectOpts.add(List<String>.from(question['respuestas']
            ['incorrectas'])); //Se añaden las respuestas incorrectas como lista
      }
      buildLevelQuestionsList();
    } catch (e) {
      print('Exception catched: $e');
    }
  }

  void buildLevelQuestionsList() {
    try {
      for (int i = 0; i < questions.length; i++) {
        levelQuestions.add(QuizQuestion(
            question: questions[i],
            correctOpt: correctOpts[i],
            incorrectOpts: incorrectOpts[
                i])); //Se generan las preguntas en el objeto QuizQuestion y se añaden a una lista
      }
      levelQuestionsCopy =
          levelQuestions; //Se asigna los valores de una lista de las preguntas a otra
    } catch (e) {
      print("Exception in builLevelQuestionsList(): $e");
    }
  }

  // Aquí se puede agregar si es aleatoria y no se tomen en cuenta las que ya pasaron
  QuizQuestion selectQuizQuestion() {
    //Se selecciona la pregunta aleatoriamente
    QuizQuestion deliverableQuestion = QuizQuestion.empty();

    try {
      if (levelQuestionsCopy.isNotEmpty) {
        var random = Random();
        int randomNum = random.nextInt(levelQuestionsCopy.length);
        deliverableQuestion =
            levelQuestionsCopy[randomNum]; //Se genera una pregunta aleatoria
        levelQuestionsCopy.removeAt(
            randomNum); //Se remueve la pregunta de la lista de opciones -- Esto hay que preguntarlo
      }
    } catch (e) {
      print('Exception in selectQuizQuestion: $e');
    }
    return deliverableQuestion;
  }

  void returnQuestion(QuizQuestion returnedQuestion) {
    this.levelQuestionsCopy.add(returnedQuestion);
  }

  Future<void> readProgressJSONFile() async {
    try {
      String path = await getProgressFilePath();
      File file = File(path);
      if (await file.exists()) {
        String response = await file.readAsString();
        final data = await json.decode(response);

        Progress progress = Progress.constructor(
            data['nivelMaxCompletado'],
            data['nivelesSanos'],
            data['currentQuestion'],
            parseDateString(data['ultimoInicio']));
        quizProgress = progress;
        compareDates();
      } else {
        updateProgressJSONFile();
        readProgressJSONFile();
      }
    } catch (e) {
      print('Exception catched: $e');
    }
  }

  Future<String> getProgressFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/progress.json'; //Se llamaba progreso
  }

  Future<void> createProgressJSONFile(Map<String, dynamic> jsonData) async {
    String path = await getProgressFilePath();
    String jsonString = json.encode(jsonData);
    File file = File(path);
    file.writeAsStringSync(jsonString);
    print("Json guardado en dirección: $path");
  }

  Future<void> updateProgressJSONFile() async {
    DateTime fecha = quizProgress.getLastLogin();
    String fechaString = '${fecha.day}/${fecha.month}/${fecha.year}';
    Map<String, dynamic> data = {
      "nivelMaxCompletado": quizProgress.getMaxLevel(),
      "nivelesSanos": quizProgress.getHealthyLevels(), //Esto no servirá pronto
      "preguntaActual": quizProgress.getCurrentQuestion(),
      "ultimoInicio": fechaString
    };
    await createProgressJSONFile(data); //Se sobrescribe el progreso actual
  }

  DateTime parseDateString(String date) {
    DateFormat format = DateFormat('d/M/yyyy');
    DateTime dateTime = format.parse(date);
    return dateTime;
  }

  void compareDates() {
    DateTime registeredDate = quizProgress.getLastLogin();
    DateTime currentDate = DateTime.now();

    Duration difference = currentDate.difference(registeredDate);
    int differenceInDays = difference.inDays;

    if (differenceInDays > 4) {
      //print('Han pasado más de 4 días desde la fecha registrada');
      quizProgress.decreaseHealthyLevels();
    }
    //Actualizar el JSON con la fecha actual
    quizProgress.updateLastLogin();
    updateProgressJSONFile();
  }
}
