import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudyHistoryScreen extends StatelessWidget {
  const StudyHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("User not logged in"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Study History"),
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('chats')
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
              child: CircularProgressIndicator(),
            );
          }

          /// No Data
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No history yet",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }

          final chats = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chatDoc = chats[index];

              final chat =
              chatDoc.data() as Map<String, dynamic>;

              final question =
                  chat['question'] ?? "";

              final answer =
                  chat['answer'] ?? "";

              final mode =
                  chat['mode'] ?? "";

              final createdAt =
              chat['createdAt'] as Timestamp;

              return Dismissible(
                key: Key(chatDoc.id),

                direction:
                DismissDirection.endToStart,

                background: Container(
                  alignment:
                  Alignment.centerRight,
                  padding:
                  const EdgeInsets.only(
                      right: 20),
                  color: Colors.red,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),

                onDismissed: (_) async {
                  await chatDoc.reference
                      .delete();

                  ScaffoldMessenger.of(
                      context)
                      .showSnackBar(
                    const SnackBar(
                      content:
                      Text("Chat deleted"),
                    ),
                  );
                },

                child: Card(
                  margin:
                  const EdgeInsets.only(
                      bottom: 12),

                  child: ListTile(
                    contentPadding:
                    const EdgeInsets.all(
                        14),

                    /// QUESTION
                    title: Text(
                      question,
                      style:
                      const TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    /// ANSWER PREVIEW
                    subtitle: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        const SizedBox(
                            height: 6),

                        Text(
                          answer,
                          maxLines: 2,
                          overflow:
                          TextOverflow
                              .ellipsis,
                          style:
                          const TextStyle(
                            color:
                            Colors.grey,
                          ),
                        ),

                        const SizedBox(
                            height: 8),

                        Row(
                          children: [

                            /// MODE CHIP
                            Chip(
                              label: Text(
                                mode,
                                style:
                                const TextStyle(
                                    fontSize:
                                    12),
                              ),
                              backgroundColor:
                              mode ==
                                  "education"
                                  ? Colors
                                  .green
                                  .withOpacity(
                                  0.2)
                                  : Colors
                                  .blue
                                  .withOpacity(
                                  0.2),
                            ),

                            const SizedBox(
                                width: 10),

                            /// DATE
                            Text(
                              _formatDate(
                                  createdAt),
                              style:
                              const TextStyle(
                                fontSize: 12,
                                color:
                                Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    /// TAP ACTION
                    onTap: () {
                      _showFullAnswer(
                        context,
                        question,
                        answer,
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// FORMAT DATE
  static String _formatDate(
      Timestamp timestamp) {
    final date =
    timestamp.toDate();

    return "${date.day}/${date.month}/${date.year}";
  }

  /// SHOW FULL ANSWER
  static void _showFullAnswer(
      BuildContext context,
      String question,
      String answer,
      ) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(question),
          content:
          SingleChildScrollView(
            child: Text(answer),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child:
              const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}