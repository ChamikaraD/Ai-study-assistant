import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/question_model.dart';

class ChatService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  /// SAVE CHAT
  Future<void> saveChat({
    required String question,
    required String answer,
    required String mode,
  }) async {
    try {
      final user = _auth.currentUser;

      print("USER ID: ${user?.uid}");

      if (user == null) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('chats')
          .add({
        'question': question,
        'answer': answer,
        'mode': mode,
        'createdAt': Timestamp.now(),
      });

      print("CHAT SAVED SUCCESSFULLY");

    } catch (e) {
      print("Save chat error: $e");
    }
  }
}