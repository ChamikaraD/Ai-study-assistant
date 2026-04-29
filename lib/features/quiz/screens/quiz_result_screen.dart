import 'package:flutter/material.dart';



// This screen shows the final quiz result
class QuizResultScreen extends StatelessWidget {

  // User's score
  final int score;

  // Total number of questions
  final int total;


  const QuizResultScreen({
    super.key,
    required this.score,
    required this.total,
  });



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // Top app bar with title
      appBar: AppBar(
        title: const Text("Result"),
      ),


      body: Center(

        child: Column(

          // Center everything vertically
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            // Trophy icon for visual feedback
            const Icon(
              Icons.emoji_events,
              size: 80,
              color: Colors.amber,
            ),


            const SizedBox(height: 25),


            // Label text
            Text(
              "Your Score",
              style: TextStyle(
                fontSize: 20,
              ),
            ),


            const SizedBox(height: 12),


            // Display score
            Text(
              "$score / $total",
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),


            const SizedBox(height: 30),


            // Button to go back to previous screen
            ElevatedButton(

              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Back"),

            )

          ],

        ),

      ),

    );

  }

}