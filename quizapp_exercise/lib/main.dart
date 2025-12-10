import 'package:flutter/material.dart';
import 'data/repositories/quiz_repository.dart';
import 'domain/models/quiz.dart';
import 'domain/models/answer.dart';
import 'ui/screens/start_screen.dart';
import 'ui/screens/quiz_screen.dart';
import 'ui/screens/result_screen.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const QuizHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QuizHome extends StatefulWidget {
  const QuizHome({super.key});

  @override
  State<QuizHome> createState() => _QuizHomeState();
}

class _QuizHomeState extends State<QuizHome> {

  String currentScreen = 'start';
  late Quiz quiz;

  @override
  void initState() {
    super.initState();
    quiz = Quiz(questions: quizQuestions);
  }

  void startQuiz() {
    setState(() {
      quiz.clearAnswers();
      currentScreen = 'quiz';
    });
  }

  void finishQuiz() {
    setState(() {
      currentScreen = 'result';
    });
  }

  void goHome() {
    setState(() {
      currentScreen = 'start';
    });
  }

  void addAnswer(Answer answer) {
    quiz.addAnswer(answer);
  }

  void removeLastAnswer() {
    quiz.removeLastAnswer();
  }

  @override
  Widget build(BuildContext context) {
    switch (currentScreen) {
      case 'quiz':
        return QuizScreen(
          quiz: quiz,
          onFinish: finishQuiz,
          onAddAnswer: addAnswer,
          onRemoveAnswer: removeLastAnswer,
        );
      case 'result':
        return ResultScreen(
          quiz: quiz,
          onRetake: startQuiz,
          onHome: goHome,
        );
      default:
        return StartScreen(onStart: startQuiz);
    }
  }
}