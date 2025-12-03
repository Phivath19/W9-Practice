import 'package:flutter/material.dart';
import '../../domain/models/quiz.dart';
import '../../domain/models/quiz_result.dart';
import '../widgets/app_button.dart';

class ResultScreen extends StatelessWidget {
  final Quiz quiz;
  final QuizResult quizResult;
  final VoidCallback onRetakeQuiz;
  final VoidCallback onBackToHome;

  const ResultScreen({
    Key? key,
    required this.quiz,
    required this.quizResult,
    required this.onRetakeQuiz,
    required this.onBackToHome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = quizResult.getPercentage();
    final isPass = percentage >= 60;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Score card
            Container(
              color: isPass ? Colors.green[400] : Colors.red[400],
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      isPass ? 'Great Job!' : 'Try Again!',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${quizResult.score}/${quizResult.totalQuestions}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$percentage%',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Question results
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Results',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: quizResult.questionResults.length,
                    itemBuilder: (context, index) {
                      final result = quizResult.questionResults[index];
                      final isCorrect = result.isCorrect;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isCorrect ? Colors.green : Colors.red,
                                      ),
                                      child: Icon(
                                        isCorrect
                                            ? Icons.check
                                            : Icons.close,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Question ${index + 1}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  result.question,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Your answer: ${result.userAnswer}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isCorrect ? Colors.green : Colors.red,
                                  ),
                                ),
                                if (!isCorrect) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Correct answer: ${result.correctAnswer}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  AppButton(
                    label: 'Retake Quiz',
                    width: double.infinity,
                    backgroundColor: Colors.blue[400],
                    onPressed: onRetakeQuiz,
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Back to Home',
                    width: double.infinity,
                    backgroundColor: Colors.grey[400],
                    onPressed: onBackToHome,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
