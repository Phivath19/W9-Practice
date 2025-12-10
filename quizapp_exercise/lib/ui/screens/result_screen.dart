import 'package:flutter/material.dart';
import '../../domain/models/quiz.dart';
import '../widgets/app_button.dart';

class ResultScreen extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback onRetake;
  final VoidCallback onHome;

  const ResultScreen({
    super.key,
    required this.quiz,
    required this.onRetake,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    final score = quiz.getScore();
    final maxScore = quiz.getMaxScore();
    final percentage = ((score / maxScore) * 100).toInt();
    final passed = score >= 55;  

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Score header
            Container(
              width: double.infinity,
              color: passed ? Colors.green[400] : Colors.red[400],
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Text(
                    passed ? 'Great Job!' : 'Try Again!',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$score / $maxScore',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '$percentage%',
                    style: const TextStyle(fontSize: 24, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    passed ? 'You passed!' : 'You need 55 points to pass',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
            
            // Results list
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Results',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  for (int i = 0; i < quiz.answers.length; i++)
                    _buildResultCard(i),
                ],
              ),
            ),
            
            // Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AppButton(
                    text: 'Retake Quiz',
                    color: Colors.blue,
                    onPressed: onRetake,
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    text: 'Back to Home',
                    color: Colors.grey,
                    onPressed: onHome,
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

  Widget _buildResultCard(int index) {
    final answer = quiz.answers[index];
    final isCorrect = answer.isCorrect();
    final pointsEarned = answer.getPoint();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'Question ${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  '+$pointsEarned pts',
                  style: TextStyle(
                    color: isCorrect ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Question title
            Text(answer.question.title),
            const SizedBox(height: 8),
            
            // User answer
            Text(
              'Your answer: ${answer.answerChoice}',
              style: TextStyle(color: isCorrect ? Colors.green : Colors.red),
            ),
            
            // Show correct answer if wrong
            if (!isCorrect)
              Text(
                'Correct: ${answer.question.goodChoice}',
                style: const TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}