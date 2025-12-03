class QuizResult {
  final int score;
  final int totalQuestions;
  final DateTime timestamp;
  final List<QuestionResult> questionResults;

  QuizResult({
    required this.score,
    required this.totalQuestions,
    required this.timestamp,
    required this.questionResults,
  });

  int getPercentage() {
    if (totalQuestions == 0) return 0;
    return ((score / totalQuestions) * 100).toInt();
  }

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      score: json['score'] as int,
      totalQuestions: json['totalQuestions'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      questionResults: (json['questionResults'] as List)
          .map((qr) => QuestionResult.fromJson(qr as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'totalQuestions': totalQuestions,
      'timestamp': timestamp.toIso8601String(),
      'questionResults': questionResults.map((qr) => qr.toJson()).toList(),
    };
  }
}

class QuestionResult {
  final String question;
  final String userAnswer;
  final String correctAnswer;
  final bool isCorrect;

  QuestionResult({
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
  });

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    return QuestionResult(
      question: json['question'] as String,
      userAnswer: json['userAnswer'] as String,
      correctAnswer: json['correctAnswer'] as String,
      isCorrect: json['isCorrect'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'userAnswer': userAnswer,
      'correctAnswer': correctAnswer,
      'isCorrect': isCorrect,
    };
  }
}
