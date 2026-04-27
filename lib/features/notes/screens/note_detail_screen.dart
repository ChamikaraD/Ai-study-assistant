import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Screen to display details of a single note
class NoteDetailScreen extends StatelessWidget {
  final String noteId;

  const NoteDetailScreen({super.key, required this.noteId});

  @override
  // Get currently logged-in user
  // NOTE: Assumes user is always logged in (null check not handled safely)
  Widget build(BuildContext context) {
    // Get currently logged-in user
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      // App bar with static title
      appBar: AppBar(title: const Text("Note")),
      // FutureBuilder is used to fetch note data asynchronously from Firestore
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('notes')
            .doc(noteId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Extract document data and cast to Map
          // ⚠️ Potential crash if document doesn't exist or data is null
          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(data["fileName"] ?? "Note"),
          );
        },
      ),
    );
  }
}
