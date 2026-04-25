import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  final String question;
  final String answer;
  final String mode;
  final Timestamp createdAt;

  QuestionModel({
    required this.question,
    required this.answer,
    required this.mode,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
      'mode': mode,
      'createdAt': createdAt,
    };
  }

  factory QuestionModel.fromMap(
      Map<String, dynamic> map) {
    return QuestionModel(
      question: map['question'],
      answer: map['answer'],
      mode: map['mode'],
      createdAt: map['createdAt'],
    );
  }
}