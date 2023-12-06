import 'package:flutter/material.dart';
import 'package:diabetic_app/my_widgets/quiz_option_widget.dart';
import 'dart:math';

class QuestionCardWidget extends StatelessWidget {
  String question = '';
  List<QuizOptionWidget> answerOptions = [];

  QuestionCardWidget(String question, List<QuizOptionWidget> buttons,
      {super.key}) {
    this.question = question;
    answerOptions = sortAnswerOptions(buttons);
  }

  List<QuizOptionWidget> sortAnswerOptions(List<QuizOptionWidget> options) {
    List<QuizOptionWidget> result = [];

    try {
      List<QuizOptionWidget> availableOptions = List.from(options);

      if (availableOptions.isNotEmpty) {
        for (int i = 0; i < options.length; i++) {
          var random = Random();
          int selected = random.nextInt(availableOptions.length);
          result.add(availableOptions[selected]);
          availableOptions.removeAt(selected);
        }
      }
    } catch (e) {
      print('Exception at sortAnswerOptions in QuestionCardWidget: $e');
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Card(
          color: Color(0xFFC8E1F9),
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Column(
              children: [
                Text(
                  question,
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: answerOptions.length,
                  padding: const EdgeInsets.all(50.0),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          //width: 200,
                          height: 30,
                        ),
                        answerOptions[index],
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
