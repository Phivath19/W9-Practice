class Question {
  final String title;
  final List<String> choices;
  final String goodChoice;

  Question({
    required this.title,
    required this.choices,
    required this.goodChoice,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      title: json['title'] as String,
      choices: List<String>.from(json['choices'] as List),
      goodChoice: json['goodChoice'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'choices': choices,
      'goodChoice': goodChoice,
    };
  }
}
