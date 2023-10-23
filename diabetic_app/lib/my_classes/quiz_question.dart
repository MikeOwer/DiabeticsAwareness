
class QuizQuestion {
  String question = '';
  String correctOpt = '';
  List<String> incorrectOpts;

  QuizQuestion({required this.question, required this.correctOpt, required this.incorrectOpts});

  QuizQuestion.empty() : this.incorrectOpts = [];

}
