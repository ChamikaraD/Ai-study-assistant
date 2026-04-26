import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';

import '../../../services/pdf_service.dart';
import '../../quiz/screens/quize_screen.dart';
import 'edit_summary_screen.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() =>
      _SummaryScreenState();
}

class _SummaryScreenState
    extends State<SummaryScreen> {
  final user =
      FirebaseAuth.instance.currentUser;

  final TextEditingController
  _searchController =
  TextEditingController();

  String searchQuery = "";
  bool showFavoritesOnly = false;

  /////////////////////////////////////////////////////////////

  Future<void> _shareSummary(
      String title,
      String summary,
      ) async {
    await Share.share(
        "$title\n\n$summary");
  }

  /////////////////////////////////////////////////////////////

  Future<void> _toggleFavorite(
      String docId,
      bool currentValue,
      ) async {
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('summaries')
        .doc(docId)
        .update({
      "isFavorite": !currentValue,
    });
  }

  /////////////////////////////////////////////////////////////

  Future<void> _deleteSummary(
      String docId) async {
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('summaries')
        .doc(docId)
        .delete();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text("Summary deleted"),
      ),
    );
  }

  /////////////////////////////////////////////////////////////

  Future<bool> _confirmDelete(
      String docId) async {
    final result =
    await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title:
        const Text("Delete Summary"),
        content: const Text(
            "Are you sure you want to delete this summary?"),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(
                    context, false),
            child:
            const Text("Cancel"),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(
                    context, true),
            child: const Text(
              "Delete",
              style: TextStyle(
                  color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      await _deleteSummary(docId);
      return true;
    }

    return false;
  }

  /////////////////////////////////////////////////////////////

  String _timeAgo(
      Timestamp? timestamp) {
    if (timestamp == null) return "";

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

  /////////////////////////////////////////////////////////////
  /// POPUP SUMMARY WITH ICONS

  void _openSummaryDialog(
      String docId,
      String title,
      String summary,
      bool isFavorite,
      ) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(16),
        ),
        child: Padding(
          padding:
          const EdgeInsets.all(16),
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [

              //////////////////////////////////////////////////////
              /// TITLE

              Text(
                title,
                style:
                const TextStyle(
                  fontSize: 18,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              //////////////////////////////////////////////////////
              /// SUMMARY

              Container(
                constraints:
                const BoxConstraints(
                  maxHeight: 300,
                ),
                child:
                SingleChildScrollView(
                  child: Text(
                    summary,
                    style:
                    const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              //////////////////////////////////////////////////////
              /// ICON ACTIONS

              Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceEvenly,
                children: [

                  _dialogIcon(
                    icon: isFavorite
                        ? Icons.favorite
                        : Icons
                        .favorite_border,
                    label: "Favorite",
                    onTap: () {
                      _toggleFavorite(
                        docId,
                        isFavorite,
                      );
                      Navigator.pop(
                          context);
                    },
                  ),

                  _dialogIcon(
                    icon: Icons.share,
                    label: "Share",
                    onTap: () {
                      _shareSummary(
                        title,
                        summary,
                      );
                    },
                  ),

                  _dialogIcon(
                    icon: Icons.quiz,
                    label: "Quiz",
                    onTap: () {
                      Navigator.pop(
                          context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              QuizScreen(
                                summary:
                                summary,
                              ),
                        ),
                      );
                    },
                  ),

                  _dialogIcon(
                    icon:
                    Icons.picture_as_pdf,
                    label: "PDF",
                    onTap: () async {
                      await PdfService
                          .exportSummaryToPdf(
                        title,
                        summary,
                      );
                    },
                  ),

                  _dialogIcon(
                    icon: Icons.edit,
                    label: "Edit",
                    onTap: () {
                      Navigator.pop(
                          context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EditSummaryScreen(
                                docId:
                                docId,
                                title:
                                title,
                                summary:
                                summary,
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              //////////////////////////////////////////////////////
              /// CLOSE BUTTON

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pop(
                          context),
                  child: const Text(
                    "Close",
                    style: TextStyle(
                      fontSize: 16,
                      color:
                      Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /////////////////////////////////////////////////////////////
  /// ICON WIDGET

  Widget _dialogIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius:
      BorderRadius.circular(10),
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.blue,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style:
            const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /////////////////////////////////////////////////////////////

  @override
  Widget build(
      BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
              "User not logged in"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title:
        const Text("My Summaries"),
        centerTitle: true,
      ),

      body: Column(
        children: [

          //////////////////////////////////////////////////////
          /// SEARCH

          Padding(
            padding:
            const EdgeInsets.all(
                16),
            child: TextField(
              controller:
              _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery =
                      value
                          .toLowerCase();
                });
              },
              decoration:
              InputDecoration(
                hintText:
                "Search summaries...",
                prefixIcon:
                const Icon(
                    Icons.search),
                filled: true,
                fillColor:
                Colors.grey
                    .shade100,
                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius
                      .circular(
                      12),
                  borderSide:
                  BorderSide.none,
                ),
              ),
            ),
          ),

          //////////////////////////////////////////////////////
          /// LIST

          Expanded(
            child: StreamBuilder<
                QuerySnapshot>(
              stream:
              FirebaseFirestore
                  .instance
                  .collection(
                  'users')
                  .doc(user!.uid)
                  .collection(
                  'summaries')
                  .orderBy(
                'createdAt',
                descending:
                true,
              )
                  .snapshots(),

              builder:
                  (context, snapshot) {

                if (snapshot
                    .connectionState ==
                    ConnectionState
                        .waiting) {
                  return const Center(
                    child:
                    CircularProgressIndicator(),
                  );
                }

                if (!snapshot
                    .hasData ||
                    snapshot.data!.docs
                        .isEmpty) {
                  return const Center(
                    child: Text(
                        "No summaries yet"),
                  );
                }

                final docs =
                    snapshot.data!.docs;

                return ListView.builder(
                  padding:
                  const EdgeInsets
                      .all(16),
                  itemCount:
                  docs.length,
                  itemBuilder:
                      (context, index) {
                    final doc =
                    docs[index];

                    final data =
                    doc.data()
                    as Map<
                        String,
                        dynamic>;

                    final title =
                        data['title'] ??
                            "Summary";

                    final summary =
                        data['summary'] ??
                            "";

                    final createdAt =
                    data['createdAt'];

                    final isFavorite =
                        data['isFavorite'] ??
                            false;

                    return Card(
                      margin:
                      const EdgeInsets
                          .only(
                          bottom:
                          12),
                      child: ListTile(
                        leading:
                        const Icon(
                          Icons
                              .description,
                          color:
                          Colors.blue,
                        ),
                        title:
                        Text(title),
                        subtitle:
                        Text(
                          _timeAgo(
                              createdAt),
                        ),
                        trailing:
                        IconButton(
                          icon: Icon(
                            isFavorite
                                ? Icons
                                .star
                                : Icons
                                .star_border,
                            color:
                            Colors.amber,
                          ),
                          onPressed: () {
                            _toggleFavorite(
                              doc.id,
                              isFavorite,
                            );
                          },
                        ),
                        onTap: () {
                          _openSummaryDialog(
                            doc.id,
                            title,
                            summary,
                            isFavorite,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}