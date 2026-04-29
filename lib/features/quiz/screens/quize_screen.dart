import 'package:flutter/material.dart';

import '../../../services/openai_services.dart';

import 'quiz_result_screen.dart';



// This screen shows the quiz generated from the summary
class QuizScreen extends StatefulWidget {

  final String summary;


  const QuizScreen({
    super.key,
    required this.summary,
  });


  @override
  State<QuizScreen> createState() => _QuizScreenState();

}



// Handles quiz logic and UI updates
class _QuizScreenState extends State<QuizScreen> {

  // Service to generate quiz using AI
  final OpenAIService _aiService = OpenAIService();


  // Stores all quiz questions
  List<Map<String, dynamic>> quiz = [];


  // Stores user's selected answers
  Map<int, String> answers = {};


  // Loading state while quiz is being generated
  bool isLoading = true;


  // Final score
  int score = 0;



  @override
  void initState() {
    super.initState();

    // Generate quiz when screen loads
    generateQuiz();
  }



  // Calls AI service and gets quiz data
  Future<void> generateQuiz() async {

    quiz = await _aiService.generateQuiz(
      widget.summary,
    );


    // Stop loading once data is ready
    setState(() {
      isLoading = false;
    });

  }



  // Calculates score and navigates to result screen
  void submitQuiz() {

    score = 0;


    // Check each answer
    for (int i = 0; i < quiz.length; i++) {

      if (answers[i] == quiz[i]["correctAnswer"]) {
        score++;
      }

    }


    // Go to result screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultScreen(
          score: score,
          total: quiz.length,
        ),
      ),
    );

  }



  @override
  Widget build(BuildContext context) {

    // Show loading spinner while quiz is generating
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }



    return Scaffold(

      appBar: AppBar(
        title: const Text("Quiz"),
      ),



      // List of questions
      body: ListView.builder(

        padding: const EdgeInsets.all(16),

        itemCount: quiz.length,

        itemBuilder: (context, index) {

          final question = quiz[index]["question"];

          final options = List<String>.from(
            quiz[index]["options"],
          );



          return Card(

            margin: const EdgeInsets.only(bottom: 20),

            child: Padding(

              padding: const EdgeInsets.all(16),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  // Question text
                  Text(
                    question,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),


                  const SizedBox(height: 15),


                  // Options (radio buttons)
                  ...options.map((option) {

                    return RadioListTile<String>(

                      title: Text(option),

                      value: option,

                      groupValue: answers[index],


                      // Save selected answer
                      onChanged: (value) {
                        setState(() {
                          answers[index] = value!;
                        });
                      },

                    );

                  }),

                ],

              ),

            ),

          );

        },

      ),



      // Submit button
      floatingActionButton: FloatingActionButton.extended(

        onPressed: submitQuiz,

        label: const Text("Submit Quiz"),

        icon: const Icon(Icons.check),

      ),

    );

  }

}