// ============================================================
// SECTION 2: record_lecture_screen.dart
// lib/features/recording/screens/record_lecture_screen.dart
// ============================================================

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controllers/recording_controller.dart';
import '../widgets/waveform_widget.dart';

class RecordLectureScreen extends StatelessWidget {
  const RecordLectureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecordingController(),
      child: const _RecordLectureView(),
    );
  }
}

// ── Main view ─────────────────────────────────────────────────

class _RecordLectureView extends StatelessWidget {
  const _RecordLectureView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RecordingController>();

    return Scaffold(
      backgroundColor: const Color(0xFFD6E0F0),
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // ── Recording card — reduced height ─────────────
            SizedBox(
              height: 520,
              child: _RecordingCard(controller: controller),
            ),
            // Small fixed gap moves buttons up close to the card
            const SizedBox(height: 20),
            // ── Upload Audio ────────────────────────────────
            _UploadAudioButton(controller: controller),
            const SizedBox(height: 10),
            // ── Convert to Summarize Text ───────────────────
            _ConvertButton(controller: controller),
            const SizedBox(height: 20),
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
                'Record Audio',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Text(
                'Capture audio and convert to text',
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

// ── Recording Card ────────────────────────────────────────────

class _RecordingCard extends StatelessWidget {
  final RecordingController controller;

  const _RecordingCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF91BFF6), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Uploaded file badge (shown when a file is loaded)
          if (controller.hasUploadedFile) ...[
            _UploadedFileBadge(fileName: controller.uploadedFileName ?? ''),
            const SizedBox(height: 16),
          ],
          // Microphone with animated waves
          GestureDetector(
            onTap: () => _onMicTap(controller),
            child: MicrophoneIcon(isAnimating: controller.isRecording),
          ),
          const SizedBox(height: 24),
          // Timer display  e.g. "00:45"
          Text(
            controller.formattedTime,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          // Pause / Play toggle
          GestureDetector(
            onTap: () => _onMicTap(controller),
            child: Icon(
              controller.isRecording ? Icons.pause : Icons.play_arrow,
              size: 40,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _onMicTap(RecordingController controller) {
    if (controller.isRecording) {
      controller.pauseRecording();
    } else if (controller.isPaused) {
      controller.resumeRecording();
    } else {
      controller.startRecording();
    }
  }
}

// ── Uploaded file badge ───────────────────────────────────────

class _UploadedFileBadge extends StatelessWidget {
  final String fileName;

  const _UploadedFileBadge({required this.fileName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF3D7BF4).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF3D7BF4).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.audio_file, size: 18, color: Color(0xFF3D7BF4)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF3D7BF4),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Upload Audio Button ───────────────────────────────────────

class _UploadAudioButton extends StatelessWidget {
  final RecordingController controller;

  const _UploadAudioButton({required this.controller});

  // Allowed audio extensions
  static const List<String> _audioExtensions = [
    'mp3', 'wav', 'm4a', 'aac', 'ogg', 'flac', 'wma', 'mp4',
  ];

  Future<void> _pickAudioFile(BuildContext context) async {
    // Show loading state
    controller.setUploading(true);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _audioExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = result.files.single;
        controller.setUploadedFile(file.path!, file.name);

        // Show success snackbar
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Uploaded: ${file.name}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF3D7BF4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        // User cancelled — clear uploading state
        controller.setUploading(false);
      }
    } catch (e) {
      controller.setUploading(false);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick file: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUploading = controller.isUploading;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        // Disable while a pick is already in progress
        onPressed: isUploading ? null : () => _pickAudioFile(context),
        icon: isUploading
            ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Icon(Icons.upload, color: Colors.white, size: 20),
        label: Text(
          isUploading ? 'Uploading…' : 'Upload  Audio',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3D7BF4),
          disabledBackgroundColor: const Color(0xFF3D7BF4).withOpacity(0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

// ── Convert to Summarize Text Button ─────────────────────────

class _ConvertButton extends StatelessWidget {
  final RecordingController controller;

  const _ConvertButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    // Enable only when there is something to convert
    final canConvert = controller.hasUploadedFile ||
        controller.isStopped ||
        controller.isPaused ||
        controller.isRecording;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        // push() keeps /record-lecture in the back-stack so
        // context.pop() on the transcription screen works correctly.
        onPressed: canConvert
            ? () => context.push('/transcription', extra: controller)
            : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF3D7BF4),
          side: BorderSide(
            color: canConvert
                ? const Color(0xFF3D7BF4)
                : const Color(0xFF3D7BF4),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Convert to Summarize Text',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: canConvert
                ? const Color(0xFF3D7BF4)
                : const Color(0xFF3D7BF4),
          ),
        ),
      ),
    );
  }
}