import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Screen to edit an existing summary
class EditSummaryScreen extends StatefulWidget {
  final String docId;
  final String title;
  final String summary;

  const EditSummaryScreen({
    super.key,
    required this.docId,
    required this.title,
    required this.summary,
  });

  @override
  State<EditSummaryScreen> createState() => _EditSummaryScreenState();
}

class _EditSummaryScreenState extends State<EditSummaryScreen> {
  // get current logged in user
  final user = FirebaseAuth.instance.currentUser;

  // controllers to manage input fields
  late TextEditingController titleController;
  late TextEditingController summaryController;

  // loading state for save button
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.title);
    summaryController = TextEditingController(text: widget.summary);
  }

  ////////////////////////////////////////////////////
  /// function to update Firestore
  Future<void> updateSummary() async {
    if (user == null) return;

    setState(() => isSaving = true);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('summaries')
        .doc(widget.docId)
        .update({
          'title': titleController.text.trim(),
          'summary': summaryController.text.trim(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

    //stop loading state
    setState(() => isSaving = false);

    if (mounted) {
      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Summary updated")));
    }
  }

  ////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Summary")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //////////////////////////////////////
            /// TITLE INPUT FIELD
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            //////////////////////////////////////
            /// SUMMARY INPUT FIELD
            Expanded(
              child: TextField(
                controller: summaryController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  labelText: "Summary",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            //////////////////////////////////////
            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : updateSummary,
                child: isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
