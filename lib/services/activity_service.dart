import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/activity_model.dart';
import 'package:async/async.dart';

class ActivityService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  /// ===============================
  /// STREAM ALL RECENT ACTIVITIES
  /// ===============================
  Stream<List<ActivityModel>>
  streamRecentActivities() {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    final uid = user.uid;

    /// Listen to all collections
    final chatsStream = _firestore
        .collection('users')
        .doc(uid)
        .collection('chats')
        .snapshots();

    final summariesStream = _firestore
        .collection('users')
        .doc(uid)
        .collection('summaries')
        .snapshots();

    final recordingsStream = _firestore
        .collection('users')
        .doc(uid)
        .collection('recordings')
        .snapshots();

    final notesStream = _firestore
        .collection('users')
        .doc(uid)
        .collection('notes')
        .snapshots();

    /// Combine streams
    return StreamZip([
      chatsStream,
      summariesStream,
      recordingsStream,
      notesStream,
    ]).map((snapshots) {
      List<ActivityModel> activities = [];

      /// Chats
      for (var doc in snapshots[0].docs) {
        activities.add(
          ActivityModel.fromChat(
              doc.id,
              doc.data()),
        );
      }

      /// Summaries
      for (var doc in snapshots[1].docs) {
        activities.add(
          ActivityModel.fromSummary(
              doc.id,
              doc.data()),
        );
      }

      /// Recordings
      for (var doc in snapshots[2].docs) {
        activities.add(
          ActivityModel.fromRecording(
              doc.id,
              doc.data()),
        );
      }

      /// Notes
      for (var doc in snapshots[3].docs) {
        activities.add(
          ActivityModel.fromNote(
              doc.id,
              doc.data()),
        );
      }

      /// Sort newest first
      activities.sort(
            (a, b) => b.createdAt
            .compareTo(a.createdAt),
      );

      /// Return latest 3
      return activities.take(3).toList();
    });
  }
}