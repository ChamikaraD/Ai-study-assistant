// ============================================================
// SECTION 1: recording_controller.dart
// lib/features/recording/controllers/recording_controller.dart
// ============================================================

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

enum RecordingState { idle, recording, paused, stopped }

class RecordingController extends ChangeNotifier {
  RecordingState _state   = RecordingState.idle;
  Duration _elapsed       = Duration.zero;
  Timer? _timer;

  /// Holds the file selected via the Upload Audio button.
  File? _uploadedFile;
  String? _uploadedFileName;
  bool _isUploading = false;

  // ── Getters ──────────────────────────────────────────────

  RecordingState get state        => _state;
  bool get isRecording            => _state == RecordingState.recording;
  bool get isPaused               => _state == RecordingState.paused;
  bool get isStopped              => _state == RecordingState.stopped;
  bool get isIdle                 => _state == RecordingState.idle;
  Duration get elapsed            => _elapsed;
  File? get uploadedFile          => _uploadedFile;
  String? get uploadedFileName    => _uploadedFileName;
  bool get isUploading            => _isUploading;
  bool get hasUploadedFile        => _uploadedFile != null;

  /// Returns elapsed time formatted as MM:SS  e.g. "00:45"
  String get formattedTime {
    final minutes = _elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = _elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // ── Upload actions ────────────────────────────────────────

  /// Call this after file_picker returns a valid path.
  void setUploadedFile(String path, String name) {
    _uploadedFile     = File(path);
    _uploadedFileName = name;
    _isUploading      = false;
    notifyListeners();
  }

  void setUploading(bool value) {
    _isUploading = value;
    notifyListeners();
  }

  void clearUploadedFile() {
    _uploadedFile     = null;
    _uploadedFileName = null;
    notifyListeners();
  }

  // ── Recording actions ────────────────────────────────────

  void startRecording() {
    _state   = RecordingState.recording;
    _elapsed = Duration.zero;
    _startTimer();
    notifyListeners();
  }

  void pauseRecording() {
    _state = RecordingState.paused;
    _timer?.cancel();
    notifyListeners();
  }

  void resumeRecording() {
    _state = RecordingState.recording;
    _startTimer();
    notifyListeners();
  }

  void stopRecording() {
    _state = RecordingState.stopped;
    _timer?.cancel();
    notifyListeners();
  }

  void reset() {
    _state            = RecordingState.idle;
    _elapsed          = Duration.zero;
    _uploadedFile     = null;
    _uploadedFileName = null;
    _isUploading      = false;
    _timer?.cancel();
    notifyListeners();
  }

  // ── Internal helpers ─────────────────────────────────────

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsed += const Duration(seconds: 1);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}