import 'package:flutter/material.dart';

class Options extends StatelessWidget {
  final String? optionText;
  final Color? answerColor;
  final VoidCallback? answerTap;

  Options({this.optionText, this.answerColor, this.answerTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: answerTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
            color: answerColor,
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(25)),
        child: Text(
          optionText.toString(),
          style: TextStyle(fontSize: 17),
        ),
      ),
    );
  }
}
