import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'summary_detail_screen.dart';

class ViewSummariesScreen extends StatelessWidget {
  const ViewSummariesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("View Summaries"),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('summaries')
            .orderBy(
          'createdAt',
          descending: true,
        )
            .snapshots(),

        builder: (context, snapshot) {
          /// Loading

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          /// Empty

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No summaries yet",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            );
          }

          final summaries =
              snapshot.data!.docs;

          return ListView.builder(
            padding:
            const EdgeInsets.all(16),

            itemCount: summaries.length,

            itemBuilder:
                (context, index) {
              final doc =
              summaries[index];

              final data =
              doc.data()
              as Map<String,
                  dynamic>;

              return Card(
                margin:
                const EdgeInsets.only(
                    bottom: 12),

                child: ListTile(
                  leading: const Icon(
                    Icons.description,
                    color: Colors.blue,
                  ),

                  title: Text(
                    data["title"] ??
                        "Summary",
                  ),

                  subtitle: Text(
                    _timeAgo(
                        data["createdAt"]),
                  ),

                  trailing: const Icon(
                    Icons
                        .arrow_forward_ios,
                    size: 14,
                  ),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SummaryDetailScreen(
                              summaryId:
                              doc.id,
                            ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Time Ago Helper

  String _timeAgo(
      Timestamp timestamp) {
    final date =
    timestamp.toDate();

    final diff =
    DateTime.now()
        .difference(date);

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