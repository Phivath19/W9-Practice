
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../domain/models/quiz.dart';
import '../../domain/models/question.dart';
import '../../domain/models/quiz_result.dart';

class QuizRepository {
  static const String quizFileName = 'quiz_data.json';
  static const String historyFileName = 'quiz_history.json';

  Future<void> resetQuizData() async {
    final file = await _getFile(quizFileName);

    if (await file.exists()) {
      await file.delete();
      print("Old quiz_data.json deleted.");
    }
  }

  Future<void> initializeQuizData() async {
    try {
      final file = await _getFile(quizFileName);

      // Always recreate fresh quiz (development mode)
      final defaultQuiz = _getDefaultQuiz();
      final json = jsonEncode(defaultQuiz.toJson());
      await file.writeAsString(json);

      print("New quiz_data.json created.");
    } catch (e) {
      print('Error initializing quiz data: $e');
    }
  }

  Future<Quiz> loadQuiz() async {
    try {
      final file = await _getFile(quizFileName);
      final content = await file.readAsString();

      final jsonData = jsonDecode(content) as Map<String, dynamic>;
      return Quiz.fromJson(jsonData);
    } catch (e) {
      print("Error loading quiz, loading default quiz: $e");
      return _getDefaultQuiz();
    }
  }

  Future<void> saveQuizResult(QuizResult result) async {
    try {
      final history = await loadQuizHistory();
      history.add(result);

      final file = await _getFile(historyFileName);
      final json = jsonEncode(history.map((e) => e.toJson()).toList());

      await file.writeAsString(json);
    } catch (e) {
      print("Error saving quiz result: $e");
    }
  }

  Future<List<QuizResult>> loadQuizHistory() async {
    try {
      final file = await _getFile(historyFileName);

      if (!await file.exists()) return [];

      final content = await file.readAsString();
      if (content.isEmpty) return [];

      final list = jsonDecode(content) as List;

      return list
          .map((item) => QuizResult.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error loading history: $e");
      return [];
    }
  }

  Future<File> _getFile(String name) async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/$name");
  }

  Quiz _getDefaultQuiz() {
    return Quiz(
      questions: [
        Question(
          title: "Who is the greatest footballer of all time?",
          choices: [
            "Lionel Messi",
            "Cristiano Ronaldo",
            "Pele",
            "Diego Maradona"
          ],
          goodChoice: "Lionel Messi",
        ),
        Question(
          title: "who is the best teacher", 
          choices: [
              "Ronan",
              "Hongly",
              "Leangsiv",
          ], 
          goodChoice: "Ronan",
          ),
           Question(
          title: "who is the best teacher", 
          choices: [
              "Ronan",
              "Hongly",
              "Leangsiv",
          ], 
          goodChoice: "Ronan",
          ),
        Question(
          title: "What is the capital of Japan?",
          choices: ["Tokyo", "Seoul", "Kyoto", "Beijing"],
          goodChoice: "Tokyo",
        ),
        Question(
          title: "Which planet is known as the Red Planet?",
          choices: ["Earth", "Jupiter", "Mars", "Venus"],
          goodChoice: "Mars",
        ),
        Question(
          title: "Which animal is the largest mammal on Earth?",
          choices: ["Elephant", "Blue Whale", "Giraffe", "Shark"],
          goodChoice: "Blue Whale",
        ),
        Question(
          title: "What is the freezing point of water?",
          choices: ["0°C", "100°C", "50°C", "-10°C"],
          goodChoice: "0°C",
        ),
        Question(
          title: "Which continent is the largest?",
          choices: ["Africa", "Asia", "North America", "Europe"],
          goodChoice: "Asia",
        ),
        Question(
          title: "What is the capital of cambodia",
          choices: ["Phnom Penh", "Svay Rieng", "Kompong cham", "AKA"],
          goodChoice: "Phnom Penh",
        ),
      ],
      answers: [],
    );
  }
}
