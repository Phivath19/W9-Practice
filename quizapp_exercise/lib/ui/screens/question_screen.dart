import 'package:flutter/material.dart';
import '../../domain/models/quiz.dart';
import '../../domain/models/answer.dart';
import '../widgets/question_widget.dart';
import '../widgets/app_button.dart';

class QuestionScreen extends StatefulWidget {
  final Quiz quiz;
  final VoidCallback onQuizComplete;

  const QuestionScreen({
    Key? key,
    required this.quiz,
    required this.onQuizComplete,
  }) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  late int _currentQuestionIndex;
  late Map<int, String> _answers;

  @override
  void initState() {
    super.initState();
    _currentQuestionIndex = 0;
    _answers = {};
  }

  void _answerSelected(String answer) {
    setState(() {
      _answers[_currentQuestionIndex] = answer;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _submitQuiz() {
    // Add all answers to quiz
    for (int i = 0; i < widget.quiz.questions.length; i++) {
      final question = widget.quiz.questions[i];
      final userAnswer = _answers[i] ?? '';
      
      widget.quiz.addAnswer(
        Answer(
          answerChoice: userAnswer,
          goodChoice: question.goodChoice,
        ),
      );
    }

    widget.onQuizComplete();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.quiz.questions[_currentQuestionIndex];
    final isLastQuestion = _currentQuestionIndex == widget.quiz.questions.length - 1;
    final isAnswered = _answers.containsKey(_currentQuestionIndex);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        backgroundColor: Colors.blue[400],
      ),
      body: Column(
        children: [
          // Question widget
          Expanded(
            child: QuestionWidget(
              question: currentQuestion,
              questionNumber: _currentQuestionIndex + 1,
              totalQuestions: widget.quiz.questions.length,
              onAnswerSelected: _answerSelected,
              selectedAnswer: _answers[_currentQuestionIndex],
            ),
          ),
          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Previous button
                Expanded(
                  child: AppButton(
                    label: 'Previous',
                    backgroundColor: Colors.grey[400],
                    textColor: Colors.white,
                    onPressed: _currentQuestionIndex > 0
                        ? _previousQuestion
                        : () {},
                  ),
                ),
                const SizedBox(width: 12),
                // Next or Submit button
                Expanded(
                  child: AppButton(
                    label: isLastQuestion ? 'Submit' : 'Next',
                    backgroundColor: isAnswered ? Colors.blue : Colors.grey,
                    textColor: Colors.white,
                    onPressed: isAnswered
                        ? (isLastQuestion ? _submitQuiz : _nextQuestion)
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select an answer'),
                              ),
                            );
                          },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
