import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:quiz_app/options.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Icon> _scoreTracker = [];
  int _questionIndex = 0;
  int _totalScore = 0;
  bool answerWasSelected = false;
  bool endOfQuiz = false;
  bool correctAnswerSelected = false;

  void _questionAnswered(bool answerScore) {
    setState(() {
      // answer was selected
      answerWasSelected = true;
      // check if answer was correct
      if (answerScore) {
        _totalScore++;
        correctAnswerSelected = true;
      }
      // adding to the score tracker on top
      _scoreTracker.add(
        answerScore
            ? Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            : Icon(
                Icons.clear,
                color: Colors.red,
              ),
      );
      //when the quiz ends
      if (_questionIndex + 1 == _questions.length) {
        endOfQuiz = true;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _questionIndex++;
      answerWasSelected = false;
      correctAnswerSelected = false;
    });
    // what happened at the end of quiz
    if (_questionIndex == _questions.length) {
      _restartQuiz();
    }
  }

  void _restartQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
      _scoreTracker = [];
      endOfQuiz = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Genral Knowledge Quiz App',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                if (_scoreTracker.length == 0)
                  SizedBox(
                    height: 30,
                  ),
                if (_scoreTracker.length > 0) ..._scoreTracker
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              height: 130.0,
              margin: EdgeInsets.only(bottom: 10, left: 30, right: 30, top: 10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  _questions[_questionIndex]["question"] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            ...(_questions[_questionIndex]['answers']
                    as List<Map<String, Object>>)
                .map(
              (answer) => Options(
                optionText: answer['answerText'].toString(),
                answerColor: answerWasSelected
                    ? answer['score'] as bool
                        ? Colors.green
                        : Colors.red
                    : null,
                answerTap: () {
                  // if answer was already selected then nothing happens on tap

                  if (answerWasSelected) {
                    return;
                  }

                  //answer is being selected
                  _questionAnswered(answer['score'] as bool);
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  if (!answerWasSelected) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Select an answer before moving to next question !')));
                    return;
                  }
                  _nextQuestion();
                },
                child: Text(endOfQuiz ? 'Restart Quiz' : 'Next Question !')),
            Container(
              padding: EdgeInsets.all(20),
              child: Text('${_totalScore.toString()}/${_questions.length}',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            ),
            if (answerWasSelected && !endOfQuiz)
              Container(
                height: 100,
                width: double.infinity,
                color: correctAnswerSelected ? Colors.green : Colors.red,
                child: Center(
                  child: Text(
                    correctAnswerSelected
                        ? 'Well Done, your answer is correct !'
                        : 'wrong answer :/ ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (endOfQuiz)
              Container(
                height: 100,
                width: double.infinity,
                color: Colors.black,
                child: Center(
                    child: Text(
                  _totalScore > 4
                      ? 'Congrats ! \n You Passed this fuking quiz, Your total score is: $_totalScore'
                      : 'better luck next time, your total score is: $_totalScore',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _totalScore > 4 ? Colors.green : Colors.red),
                )),
              )
          ],
        ),
      ),
    );
  }
}

final _questions = [
  {
    'question':
        'Which of the following was used in programming the first computers?',
    'answers': [
      {'answerText': 'machine code', 'score': true},
      {'answerText': 'object code', 'score': false},
      {'answerText': 'source code', 'score': false},
    ],
  },
  {
    'question': 'Entomology is the science that studies',
    'answers': [
      {'answerText': 'behaviour of human beings', 'score': false},
      {'answerText': 'the formation of rocks', 'score': false},
      {'answerText': 'insects', 'score': true},
    ],
  },
  {
    'question':
        'For which of the following disciplines is Nobel Prize awarded?',
    'answers': [
      {'answerText': 'physics , chemistry, physiology ', 'score': false},
      {'answerText': 'literature, peace and economics', 'score': false},
      {'answerText': 'all of the above', 'score': true},
    ],
  },
  {
    'question': 'In Georgia (the state), it’s illegal to eat what with a fork?',
    'answers': [
      {'answerText': 'Hamburgers', 'score': false},
      {'answerText': 'Fried chicken', 'score': true},
      {'answerText': 'Pizza', 'score': false},
    ],
  },
  {
    'question':
        'Which part of his body did musician Gene Simmons from Kiss insure for one million dollars?',
    'answers': [
      {'answerText': 'His tongue', 'score': true},
      {'answerText': 'His leg', 'score': false},
      {'answerText': 'His butt', 'score': false},
    ],
  },
  {
    'question': 'In which country are Panama hats made?',
    'answers': [
      {'answerText': 'Ecuador', 'score': true},
      {'answerText': 'Panama (duh)', 'score': false},
      {'answerText': 'Portugal', 'score': false},
    ],
  },
  {
    'question': 'From which country do French fries originate?',
    'answers': [
      {'answerText': 'Belgium', 'score': true},
      {'answerText': 'France (duh)', 'score': false},
      {'answerText': 'Switzerland', 'score': false},
    ],
  },
  {
    'question': 'Which sea creature has three hearts?',
    'answers': [
      {'answerText': 'Great White Sharks', 'score': false},
      {'answerText': 'Killer Whales', 'score': false},
      {'answerText': 'The Octopus', 'score': true},
    ],
  },
  {
    'question': 'Which European country eats the most chocolate per capita?',
    'answers': [
      {'answerText': 'Belgium', 'score': false},
      {'answerText': 'The Netherlands', 'score': false},
      {'answerText': 'Switzerland', 'score': true},
    ],
  },
];
