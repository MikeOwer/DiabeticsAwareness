import 'package:flutter/material.dart';

class QuizOptionWidget extends StatefulWidget {
  //Argumentos en el constructor
  final String text;
  bool isCorrect;
  final Function onTapFn;

  final Color baseColor = const Color(0xFFE0E0E0);
  Color changeColor;

  QuizOptionWidget(
      {super.key,
      required this.text,
      required this.isCorrect,
      required this.onTapFn})
      : changeColor = isCorrect ? Colors.lightGreenAccent : Colors.redAccent;

  @override
  _QuizOptionWidgetState createState() =>
      _QuizOptionWidgetState(onTapFn: onTapFn);
}

class _QuizOptionWidgetState extends State<QuizOptionWidget> {
  bool isPressed = false;
  final Function onTapFn;

  _QuizOptionWidgetState({required this.onTapFn});

  void onTap() {
    setState(() {
      isPressed = true;
    });
    onTapFn();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPressed ? widget.changeColor : widget.baseColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Container(
        width: 300,
        height: 50,
        alignment: Alignment.center,
        child: Text(
          widget.text,
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }
}
