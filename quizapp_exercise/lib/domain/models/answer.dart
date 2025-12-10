import 'question.dart';

class Answer {
  final String answerChoice;
  final Question question;

  Answer({
    required this.answerChoice,
    required this.question,
  });

  bool isCorrect() {
    return answerChoice == question.goodChoice;
  }

  // Get points if correct, 0 if wrong
  int getPoint() {
    if (isCorrect()) {
      return question.point;
    }
    return 0;
  }
}