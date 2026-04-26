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
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final user = FirebaseAuth.instance.currentUser;

  final TextEditingController _searchController =
  TextEditingController();

  String searchQuery = "";

  bool showFavoritesOnly = false;

  //////////////////////////////////////////////////////////////
  /// SHARE SUMMARY

  Future<void> _shareSummary(
      String title,
      String summary,
      ) async {
    final text = """
$title

$summary

Shared from AI Study Assistant
""";

    await Share.share(text);
  }

  //////////////////////////////////////////////////////////////
  /// TOGGLE FAVORITE

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

  //////////////////////////////////////////////////////////////
  /// DELETE

  Future<void> _deleteSummary(
      String docId,
      ) async {
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('summaries')
        .doc(docId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Summary deleted"),
      ),
    );
  }

  //////////////////////////////////////////////////////////////
  /// CONFIRM DELETE

  Future<bool> _confirmDelete(
      String docId,
      ) async {
    final result =
    await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Summary"),
        content: const Text(
            "Are you sure you want to delete this summary?"),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
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

  //////////////////////////////////////////////////////////////
  /// TIME AGO

  String _timeAgo(
      Timestamp? timestamp,
      ) {
    if (timestamp == null) return "";

    final date = timestamp.toDate();

    final diff =
    DateTime.now().difference(date);

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

  //////////////////////////////////////////////////////////////
  /// OPEN SUMMARY DIALOG

  void _openSummaryDialog(
      String docId,
      String title,
      String summary,
      ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),

        content: SingleChildScrollView(
          child: Text(summary),
        ),

        actions: [

          //////////////////////////////////////
          /// SHARE

          TextButton(
            onPressed: () async {
              await _shareSummary(
                title,
                summary,
              );
            },
            child: const Text("Share"),
          ),

          TextButton(
            onPressed: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizScreen(
                    summary: summary,
                  ),
                ),
              );
            },
            child: const Text("Generate Quiz"),
          ),

          //////////////////////////////////////
          /// EXPORT PDF

          TextButton(
            onPressed: () async {
              await PdfService.exportSummaryToPdf(
                title,
                summary,
              );
            },
            child: const Text("Export PDF"),
          ),

          //////////////////////////////////////
          /// EDIT

          TextButton(
            onPressed: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      EditSummaryScreen(
                        docId: docId,
                        title: title,
                        summary: summary,
                      ),
                ),
              );
            },
            child: const Text("Edit"),
          ),

          //////////////////////////////////////
          /// CLOSE

          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  //////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("User not logged in"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("View Summaries"),

        actions: [

          /// FAVORITE FILTER

          IconButton(
            icon: Icon(
              showFavoritesOnly
                  ? Icons.star
                  : Icons.star_border,
            ),
            onPressed: () {
              setState(() {
                showFavoritesOnly =
                !showFavoritesOnly;
              });
            },
          ),
        ],
      ),

      body: Column(
        children: [

          //////////////////////////////////////////////////////
          /// SEARCH BAR

          Padding(
            padding:
            const EdgeInsets.all(16),
            child: TextField(
              controller:
              _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery =
                      value.toLowerCase();
                });
              },
              decoration:
              InputDecoration(
                hintText:
                "Search summaries...",
                prefixIcon:
                const Icon(Icons.search),
                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          //////////////////////////////////////////////////////
          /// SUMMARY LIST

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

                if (!snapshot.hasData ||
                    snapshot.data!.docs
                        .isEmpty) {
                  return const Center(
                    child: Text(
                        "No summaries yet"),
                  );
                }

                final allDocs =
                    snapshot.data!.docs;

                //////////////////////////////////////////////////////
                /// FILTER

                final filteredDocs =
                allDocs.where(
                      (doc) {
                    final data =
                    doc.data()
                    as Map<
                        String,
                        dynamic>;

                    final title =
                        data['title']
                            ?.toLowerCase() ??
                            "";

                    final summary =
                        data['summary']
                            ?.toLowerCase() ??
                            "";

                    final isFavorite =
                        data['isFavorite'] ??
                            false;

                    if (showFavoritesOnly &&
                        !isFavorite) {
                      return false;
                    }

                    return title.contains(
                        searchQuery) ||
                        summary.contains(
                            searchQuery);
                  },
                ).toList();

                if (filteredDocs
                    .isEmpty) {
                  return const Center(
                    child: Text(
                        "No results found"),
                  );
                }

                //////////////////////////////////////////////////////
                /// LIST VIEW

                return ListView.builder(
                  padding:
                  const EdgeInsets
                      .all(16),

                  itemCount:
                  filteredDocs
                      .length,

                  itemBuilder:
                      (context, index) {

                    final doc =
                    filteredDocs[index];

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

                    return Dismissible(
                      key:
                      ValueKey(doc.id),

                      direction:
                      DismissDirection
                          .endToStart,

                      confirmDismiss:
                          (direction) async {
                        return await _confirmDelete(
                            doc.id);
                      },

                      background:
                      Container(
                        alignment:
                        Alignment
                            .centerRight,
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 20,
                        ),
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),

                      child: Card(
                        margin:
                        const EdgeInsets
                            .only(
                          bottom: 12,
                        ),

                        child:
                        ListTile(
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
                          Row(
                            mainAxisSize:
                            MainAxisSize.min,
                            children: [

                              /// FAVORITE

                              IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.star
                                      : Icons
                                      .star_border,
                                  color:
                                  Colors
                                      .amber,
                                ),
                                onPressed:
                                    () {
                                  _toggleFavorite(
                                    doc.id,
                                    isFavorite,
                                  );
                                },
                              ),

                              const Icon(
                                Icons
                                    .arrow_forward_ios,
                                size: 16,
                              ),
                            ],
                          ),

                          onTap: () {
                            _openSummaryDialog(
                              doc.id,
                              title,
                              summary,
                            );
                          },
                        ),
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