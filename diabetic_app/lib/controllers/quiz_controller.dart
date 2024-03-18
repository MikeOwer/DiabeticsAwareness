import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:diabetic_app/my_classes/quiz_question.dart';
import 'package:flutter/services.dart';
import 'package:diabetic_app/my_classes/progress.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class QuizController {
  //Se maneja toda la lógica de las preguntas del quiz
  static QuizController? _instance; //Se aplica el patrón de diseño Singleton
  List<String> questions = [];
  List<String> correctOpts = [];
  List<List<String>> incorrectOpts = [];
  List<QuizQuestion> levelQuestions = [];
  List<QuizQuestion> levelQuestionsCopy = [];
  String questionsPath = 'assets/question_files/preguntas.json';
  Progress quizProgress = Progress();
  List<String> completedQuestions = [];

  int stage = 0;

  QuizController._();

  static QuizController getInstance() {
    _instance ??= QuizController._();
    return _instance!;
  }

  void increaseStage() {
    //Se inncrementa el número de pregunta actual al responder bien una
    if (quizProgress.getMaxLevel() < 3) {
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

      if (level < 2) {
        //Esto solo funciona en los primeros dos niveles
        List<dynamic> nivelesList =
            data['niveles']; //Lee los niveles diponibles
        List<dynamic> questionsList = nivelesList[level]
            ['preguntas']; //Accede a las preguntas del nivel solicitado
        for (var question in questionsList) {
          questions.add(question['texto']); //Se añaden las preguntas
          correctOpts.add(question['respuestas']
              ['correcta']); //Se añade las respuestas correctas
          incorrectOpts.add(List<String>.from(question['respuestas'][
              'incorrectas'])); //Se añaden las respuestas incorrectas como lista
        }
      } else {
        List<dynamic> nivelesList =
            data['niveles']; //Lee los niveles diponibles
        List<dynamic> questionsList = nivelesList[level - 2]
            ['preguntas']; //Accede a las preguntas del nivel 1
        List<dynamic> questionsList2 = nivelesList[level - 1]
            ['preguntas']; //Accede a las preguntas del nivel 2
        questionsList
            .addAll(questionsList2); //Combina las preguntas de ambos niveles
        for (var question in questionsList) {
          questions.add(question['texto']); //Se añaden las preguntas
          correctOpts.add(question['respuestas']
              ['correcta']); //Se añade las respuestas correctas
          incorrectOpts.add(List<String>.from(question['respuestas'][
              'incorrectas'])); //Se añaden las respuestas incorrectas como lista
        }
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
        //Solo funcionaría en los primeros dos niveles
        levelQuestionsCopy.removeAt(
            randomNum); //Se remueve la pregunta de la lista de opciones -- Esto hay que preguntarlo
      }
    } catch (e) {
      print('Exception in selectQuizQuestion: $e');
    }
    return deliverableQuestion;
  }

  void returnQuestion(QuizQuestion returnedQuestion) {
    levelQuestionsCopy.add(returnedQuestion);
  }

  Future<void> readProgressJSONFile() async {
    try {
      String path = await getProgressFilePath(); //Se obtiene la ruta del json
      File file = File(path);
      if (await file.exists()) {
        String response = await file.readAsString();
        final data = await json
            .decode(response); //Se obtiene el Json con el que se trabajará

        Progress progress = Progress.constructor(
            data['nivelMaxCompletado'],
            data['nivelesSanos'],
            data['preguntaActual'],
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
    print(directory.path);
    return '${directory.path}/progress_test20.json'; //Se llamaba progreso --- Nombre provisional
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
      "nivelesSanos": quizProgress
          .getHealthyLevels(), //Esto servirá para mantenerse en el nivel 3
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
//-----------------------------------------------------------------------------------------------------------------------------------------
    if (differenceInDays > 4) {
      //Hay que agregar cambios aquí, se busca bajar de nivel al no responder correctamente 5 preguntas en un mes
      //Si hay 5 healthyLevels terminando el mes se mantiene el nivel 3, en caso de no haber se retrocede al nivel 2
      //print('Han pasado más de 4 días desde la fecha registrada');
      quizProgress.decreaseHealthyLevels();

      //Si se tiene los niveles de salud en 0 se reducirá un nivel de la actividad y se reiniciará el número de preguntas
      if (quizProgress.getHealthyLevels() == 0) {
        quizProgress.decreaseLevels();
        quizProgress.currentQuestion = 0;
      }
    }
    //Actualizar el JSON con la fecha actual
    quizProgress.updateLastLogin();
    updateProgressJSONFile();
  }
}
