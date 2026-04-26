import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  final String id;
  final String title;
  final String type;
  final Timestamp createdAt;

  ActivityModel({
    required this.id,
    required this.title,
    required this.type,
    required this.createdAt,
  });

  static ActivityModel fromChat(String id,Map<String, dynamic> data) {
    return ActivityModel(
      id:id,
      title: "Q&A : ${data['question']}",
      type: "chat",
      createdAt: data['createdAt'],
    );
  }

  static ActivityModel fromSummary(String id,Map<String, dynamic> data) {
    return ActivityModel(
      id:id,
      title: data['title'] ?? "Summary",
      type: "summary",
      createdAt: data['createdAt'],
    );
  }

  static ActivityModel fromRecording(String id,Map<String, dynamic> data) {
    return ActivityModel(
      id:id,
      title: "Lecture Transcription",
      type: "recording",
      createdAt: data['createdAt'],
    );
  }

  static ActivityModel fromNote(String id,Map<String, dynamic> data) {
    return ActivityModel(
      id:id,
      title: data['fileName'] ?? "Notes uploaded",
      type: "note",
      createdAt: data['createdAt'],
    );
  }
  String get timeAgo {
    final date = createdAt.toDate();

    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 60) {
      return "${diff.inMinutes} min ago";
    }

    if (diff.inHours < 24) {
      return "${diff.inHours} hours ago";
    }

    if (diff.inDays == 1) {
      return "Yesterday";
    }

    return "${diff.inDays} days ago";
  }
}