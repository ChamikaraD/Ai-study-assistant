import 'package:flutter/material.dart';

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Result"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.emoji_events,
              size: 80,
              color: Colors.amber,
            ),

            const SizedBox(height: 20),

            Text(
              "Your Score",
              style: TextStyle(
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "$score / $total",
              style: const TextStyle(
                fontSize: 36,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Back",
              ),
            )
          ],
        ),
      ),
    );
  }
}