
import 'package:flutter/material.dart';
import '../widgets/app_button.dart';

class StartScreen extends StatelessWidget {
  final VoidCallback onStartQuiz;
  final VoidCallback onViewHistory;

  const StartScreen({
    Key? key,
    required this.onStartQuiz,
    required this.onViewHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2196F3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  '?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  '?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  '?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/image/flutter1.png',
              height: 100,
              width: 100,
              fit: BoxFit.contain,
            ),
        
             const SizedBox(height: 60),
             
           ElevatedButton(
              onPressed: onStartQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
              ),
              child: Text(
                'Start Quiz',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: const Color(0xFF2196F3),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'View History',
              width: 200,
              backgroundColor: Colors.white70,
              textColor: Colors.blue[700],
              onPressed: onViewHistory,
            ),
          ],
        ),
      ),
    );
  }
}

