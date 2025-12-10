class Question {
  final String title;
  final List<String> choices;
  final String goodChoice;
  final int point;

  Question({
    required this.title,
    required this.choices,
    required this.goodChoice,
    required this.point,
  });
}