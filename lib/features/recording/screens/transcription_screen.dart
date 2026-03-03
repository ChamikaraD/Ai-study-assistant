// ============================================================
// SECTION 3: transcription_screen.dart
// lib/features/recording/screens/transcription_screen.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controllers/recording_controller.dart';

/// Receives a [RecordingController] passed as GoRouter `extra`
/// from [RecordLectureScreen] via:
///   context.go('/transcription', extra: controller)
class TranscriptionScreen extends StatelessWidget {
  final RecordingController controller;

  const TranscriptionScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E0F0),
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            // ── Transcription result card ──────────────────
            SizedBox(
              height: 580,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFD6E0F0),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _TranscriptionBody(controller: controller),
              ),
            ),
            const SizedBox(height: 16),
            // ── Done button ────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => context.go('/record-lecture'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D7BF4),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFD6E0F0),
      elevation: 0,
      automaticallyImplyLeading: false, // removes default leading gap entirely
      titleSpacing: 10,                  // small left edge padding only
      title: Row(
        children: [
          // Back arrow with zero internal padding
          GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 25,
            ),
          ),
          const SizedBox(width: 6), // tight gap between arrow and text
          // Title + subtitle placed immediately after the arrow
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Transcription',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Text(
                'Audio converted to text',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Icon(Icons.notifications_active, color: Colors.black, size: 25),
        ),
      ],
    );
  }
}

// ── Transcription body ────────────────────────────────────────

class _TranscriptionBody extends StatefulWidget {
  final RecordingController controller;

  const _TranscriptionBody({required this.controller});

  @override
  State<_TranscriptionBody> createState() => _TranscriptionBodyState();
}

class _TranscriptionBodyState extends State<_TranscriptionBody> {
  bool _isLoading = true;
  String _text = '';

  @override
  void initState() {
    super.initState();
    // Stop recording (if still running) then trigger transcription
    if (widget.controller.isRecording || widget.controller.isPaused) {
      widget.controller.stopRecording();
    }
    _transcribe();
  }

  Future<void> _transcribe() async {
    // TODO: Replace with your actual speech-to-text / summarise API call.
    // Using a short delay here to simulate the network round-trip.
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _text =
      'Your transcribed and summarised text will appear here once the '
          'audio has been processed by the speech-to-text service.';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF3D7BF4)),
            SizedBox(height: 16),
            Text(
              'Converting audio…',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_text.isEmpty) {
      return const Center(
        child: Text(
          'No transcription available.Record audio first.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    return SingleChildScrollView(
      child: Text(
        _text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
          height: 1.65,
        ),
      ),
    );
  }
}