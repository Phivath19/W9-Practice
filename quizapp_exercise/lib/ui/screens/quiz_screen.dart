
import 'package:flutter/material.dart';
import '../../domain/models/quiz.dart';
import '../../domain/models/answer.dart';
import '../widgets/app_button.dart';
import '../widgets/question_widget.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;
  final VoidCallback onFinish;
  final Function(Answer) onAddAnswer;
  final VoidCallback onRemoveAnswer;

  const QuizScreen({
    super.key,
    required this.quiz,
    required this.onFinish,
    required this.onAddAnswer,
    required this.onRemoveAnswer,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  String? selectedChoice;

  void selectAnswer(String choice) {
    setState(() {
      selectedChoice = choice;
    });
  }

  void nextQuestion() {
    if (selectedChoice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an answer')),
      );
      return;
    }

    // Save answer
    final question = widget.quiz.questions[currentIndex];
    widget.onAddAnswer(Answer(
      answerChoice: selectedChoice!,
      question: question,
    ));

    // Check if last question
    if (currentIndex < widget.quiz.questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedChoice = null;
      });
    } else {
      widget.onFinish();
    }
  }

  void prevQuestion() {
    if (currentIndex > 0) {
      widget.onRemoveAnswer();
      setState(() {
        currentIndex--;
        selectedChoice = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.quiz.questions;
    final question = questions[currentIndex];
    final isLast = currentIndex == questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        backgroundColor: Colors.blue[400],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress and points info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${currentIndex + 1} of ${questions.length}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  '${question.point} points',
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LinearProgressIndicator(
              value: (currentIndex + 1) / questions.length,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
          ),
          
          // Question title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              question.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          
          // Answer choices
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: question.choices.length,
              itemBuilder: (context, index) {
                final choice = question.choices[index];
                return AnswerOption(
                  text: choice,
                  isSelected: selectedChoice == choice,
                  onTap: () => selectAnswer(choice),
                );
              },
            ),
          ),
          
          // Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Previous',
                    color: Colors.grey,
                    onPressed: currentIndex > 0 ? prevQuestion : () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    text: isLast ? 'Submit' : 'Next',
                    color: selectedChoice != null ? Colors.blue : Colors.grey,
                    onPressed: nextQuestion,
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

