import 'question.dart';
import 'answer.dart';

class Quiz {
  final List<Question> questions;
  final List<Answer> answers;

  Quiz({
    required this.questions,
  }) : answers = [];

  // Get total score from all answers
  int getScore() {
    int score = 0;
    for (var answer in answers) {
      score += answer.getPoint();
    }
    return score;
  }

  // Get max possible score
  int getMaxScore() {
    int max = 0;
    for (var question in questions) {
      max += question.point;
    }
    return max;
  }

  // Add answer
  void addAnswer(Answer answer) {
    answers.add(answer);
  }

  // Remove last answer
  void removeLastAnswer() {
    if (answers.isNotEmpty) {
      answers.removeLast();
    }
  }

  // Clear all answers
  void clearAnswers() {
    answers.clear();
  }
}