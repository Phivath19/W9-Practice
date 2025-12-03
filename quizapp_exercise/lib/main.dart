
import 'package:flutter/material.dart';
import 'data/repositories/quiz_repository.dart';
import 'domain/models/quiz.dart';
import 'domain/models/quiz_result.dart';
import 'domain/models/answer.dart';
import 'ui/screens/start_screen.dart';
import 'ui/screens/question_screen.dart';
import 'ui/screens/result_screen.dart';
import 'ui/screens/history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = QuizRepository();

  //  Delete old JSON file (so new questions always load)
  await repository.resetQuizData();

  //  Create new JSON file with updated questions
  await repository.initializeQuizData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late QuizRepository _repository;
  late Quiz _quiz;
  late List<QuizResult> _history;
  bool _isLoading = true;
  String _currentScreen = 'home'; // home, quiz, result, history

  @override
  void initState() {
    super.initState();
    _repository = QuizRepository();
    _loadQuizData();
  }

  Future<void> _loadQuizData() async {
    try {
      final quiz = await _repository.loadQuiz();
      final history = await _repository.loadQuizHistory();

      setState(() {
        _quiz = quiz;
        _history = history;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading quiz data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startQuiz() {
    // Reset answers on start
    _quiz = Quiz(questions: _quiz.questions, answers: []);

    setState(() {
      _currentScreen = 'quiz';
    });
  }

  void _quizCompleted() async {
    final score = _quiz.getScore();
    final questionResults = <QuestionResult>[];

    for (int i = 0; i < _quiz.questions.length; i++) {
      final question = _quiz.questions[i];
      final answer = _quiz.answers[i];

      questionResults.add(
        QuestionResult(
          question: question.title,
          userAnswer: answer.answerChoice,
          correctAnswer: answer.goodChoice,
          isCorrect: answer.isCorrect(),
        ),
      );
    }

    final result = QuizResult(
      score: score,
      totalQuestions: _quiz.questions.length,
      timestamp: DateTime.now(),
      questionResults: questionResults,
    );

    await _repository.saveQuizResult(result);

    final history = await _repository.loadQuizHistory();

    setState(() {
      _history = history;
      _currentScreen = 'result';
    });
  }

  void _retakeQuiz() {
    _startQuiz();
  }

  void _backToHome() {
    setState(() {
      _currentScreen = 'home';
    });
  }

  void _viewHistory() {
    setState(() {
      _currentScreen = 'history';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.blue),
        ),
      );
    }

    switch (_currentScreen) {
      case 'home':
        return StartScreen(
          onStartQuiz: _startQuiz,
          onViewHistory: _viewHistory,
        );

      case 'quiz':
        return QuestionScreen(
          quiz: _quiz,
          onQuizComplete: _quizCompleted,
        );

      case 'result':
        final score = _quiz.getScore();
        final questionResults = <QuestionResult>[];

        for (int i = 0; i < _quiz.questions.length; i++) {
          final question = _quiz.questions[i];
          final answer = _quiz.answers[i];

          questionResults.add(
            QuestionResult(
              question: question.title,
              userAnswer: answer.answerChoice,
              correctAnswer: answer.goodChoice,
              isCorrect: answer.isCorrect(),
            ),
          );
        }

        final result = QuizResult(
          score: score,
          totalQuestions: _quiz.questions.length,
          timestamp: DateTime.now(),
          questionResults: questionResults,
        );

        return ResultScreen(
          quiz: _quiz,
          quizResult: result,
          onRetakeQuiz: _retakeQuiz,
          onBackToHome: _backToHome,
        );

      case 'history':
        return HistoryScreen(
          history: _history,
          onBackToHome: _backToHome,
        );

      default:
        return StartScreen(
          onStartQuiz: _startQuiz,
          onViewHistory: _viewHistory,
        );
    }
  }
}
