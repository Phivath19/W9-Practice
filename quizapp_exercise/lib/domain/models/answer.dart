class Answer {
  final String answerChoice;
  final String goodChoice;

  Answer({
    required this.answerChoice,
    required this.goodChoice,
  });

  bool isCorrect() {
    return answerChoice == goodChoice;
  }

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answerChoice: json['answerChoice'] as String,
      goodChoice: json['goodChoice'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answerChoice': answerChoice,
      'goodChoice': goodChoice,
    };
  }
}
