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
    if(_instance == null) {
      _instance = QuizController._();
    }
    return _instance!;
  }

  void increaseStage(){
    if(stage < 4){
      this.stage++;
    }
  }

  int getStage(){
    return stage;
  }
  void resetQuiz() {
    this.stage = 0;
  }

  Future<void> readJSONFromFile(int level) async {
    try {
      final String response = await rootBundle.loadString(questionsPath);
      final data = await json.decode(response);

      List<dynamic> nivelesList = data['niveles'];
      List<dynamic> questionsList = nivelesList[level-1]['preguntas'];
      for(var question in questionsList){
        questions.add(question['texto']);
        correctOpts.add(question['respuestas']['correcta']);
        incorrectOpts.add(
            List<String>.from(question['respuestas']['incorrectas'])
        );
      }
      buildLevelQuestionsList();
    } catch(e) {
      print('Exception catched: $e');
    }
  }

  void buildLevelQuestionsList(){
    try {
      for(int i = 0; i < questions.length; i++){
        levelQuestions.add(QuizQuestion(question: questions[i], correctOpt: correctOpts[i], incorrectOpts: incorrectOpts[i]));
      }
      levelQuestionsCopy = levelQuestions;
    }catch (e){
      print("Exception in builLevelQuestionsList(): $e");
    }
  }

  QuizQuestion selectQuizQuestion() {
    QuizQuestion deliverableQuestion = QuizQuestion.empty();

    try {
      if(levelQuestionsCopy.isNotEmpty){
        var random = Random();
        int randomNum = random.nextInt(levelQuestionsCopy.length);
        deliverableQuestion = levelQuestionsCopy[randomNum];
        levelQuestionsCopy.removeAt(randomNum);
      }
    } catch(e) {
      print('Exception in selectQuizQuestion: $e');
    }
    return deliverableQuestion;
  }

  void returnQuestion(QuizQuestion returnedQuestion){
    this.levelQuestionsCopy.add(returnedQuestion);
  }

  Future<void> readProgressJSONFile() async {
    try {
      String path = await getProgressFilePath();
      File file = File(path);
      if(await file.exists()) {
        String response = await file.readAsString();
        final data = await json.decode(response);

        Progress progress = Progress.constructor(
            data['nivelMaxCompletado'],
            data['nivelesSanos'],
            parseDateString(data['ultimoInicio'])
        );
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
    return '${directory.path}/progreso.json';
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
      "nivelesSanos": quizProgress.getHealthyLevels(),
      "ultimoInicio": fechaString
    };
    await createProgressJSONFile(data);
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






