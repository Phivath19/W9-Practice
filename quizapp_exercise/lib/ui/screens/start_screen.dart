import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  final VoidCallback onStart;

  const StartScreen({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Question marks
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '?', 
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 45, 
                    fontWeight: FontWeight.bold)
                  ),

                  SizedBox(width: 20),

                Text(
                  '?', 
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 60, 
                    fontWeight: FontWeight.bold)
                  ),

                  SizedBox(width: 20),

                Text(
                  '?', 
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 45, 
                    fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
           
            Image.asset(
              'assets/image/flutter1.png',
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 60),
            
            // Start button
            ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Start Quiz',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}