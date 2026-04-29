import 'package:flutter/material.dart';

import '../../../services/openai_services.dart';

import 'quiz_result_screen.dart';


class QuizScreen extends StatefulWidget {

  final String summary;


  const QuizScreen({
    super.key,
    required this.summary,
  });


  @override
  State<QuizScreen> createState() => _QuizScreenState();

}


class _QuizScreenState extends State<QuizScreen> {

  final OpenAIService _aiService = OpenAIService();


  List<Map<String, dynamic>> quiz = [];

  Map<int, String> answers = {};

  bool isLoading = true;

  int score = 0;


  @override
  void initState() {
    super.initState();
    generateQuiz();
  }


  Future<void> generateQuiz() async {

    quiz = await _aiService.generateQuiz(
      widget.summary,
    );

    setState(() {
      isLoading = false;
    });

  }


  void submitQuiz() {

    score = 0;

    for (int i = 0; i < quiz.length; i++) {
      if (answers[i] == quiz[i]["correctAnswer"]) {
        score++;
      }
    }


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


      body: ListView.builder(

        padding: const EdgeInsets.all(16),

        itemCount: quiz.length,

        itemBuilder: (context, index) {

          final question = quiz[index]["question"];

          final options = List<String>.from(
            quiz[index]["options"],
          );


          return Card(

            margin: const EdgeInsets.only(bottom: 16),

            child: Padding(

              padding: const EdgeInsets.all(16),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    question,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),


                  const SizedBox(height: 12),


                  ...options.map((option) {

                    return RadioListTile<String>(

                      title: Text(option),

                      value: option,

                      groupValue: answers[index],

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


      floatingActionButton: FloatingActionButton.extended(

        onPressed: submitQuiz,

        label: const Text("Submit Quiz"),

        icon: const Icon(Icons.check),

      ),

    );

  }

}