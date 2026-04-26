class QuizModel {
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuizModel({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      question: json["question"],
      options: List<String>.from(json["options"]),
      correctAnswer: json["correctAnswer"],
    );
  }
}