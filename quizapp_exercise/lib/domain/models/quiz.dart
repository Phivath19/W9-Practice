import 'question.dart';
import 'answer.dart';

class Quiz {
  final List<Question> questions;
  late List<Answer> answers;

  Quiz({
    required this.questions,
    List<Answer>? answers,
  }) {
    this.answers = answers ?? [];
  }

  int getScore() {
    int score = 0;
    for (int i = 0; i < answers.length && i < questions.length; i++) {
      if (answers[i].isCorrect()) {
        score++;
      }
    }
    return score;
  }

  void addAnswer(Answer answer) {
    if (answers.length < questions.length) {
      answers.add(answer);
    }
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    final questionsList = (json['questions'] as List)
        .map((q) => Question.fromJson(q as Map<String, dynamic>))
        .toList();
    
    final answersList = json['answers'] != null
        ? (json['answers'] as List)
            .map((a) => Answer.fromJson(a as Map<String, dynamic>))
            .toList()
        : <Answer>[];

    return Quiz(
      questions: questionsList,
      answers: answersList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questions': questions.map((q) => q.toJson()).toList(),
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }
}
