import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecordingDetailScreen
    extends StatelessWidget {
  final String recordingId;

  const RecordingDetailScreen({
    super.key,
    required this.recordingId,
  });

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title:
        const Text("Recording"),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('recordings')
            .doc(recordingId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          final data =
          snapshot.data!.data()
          as Map<String, dynamic>;

          return Padding(
            padding:
            const EdgeInsets.all(16),
            child:
            SingleChildScrollView(
              child: Text(
                data["transcript"] ??
                    "No transcript",
              ),
            ),
          );
        },
      ),
    );
  }
}