import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../services/huggingface_service.dart';
import '../../notes/screens/summary_screen.dart';

class RecordLectureScreen extends StatefulWidget {
  const RecordLectureScreen({super.key});

  @override
  State<RecordLectureScreen> createState() =>
      _RecordLectureScreenState();
}

class _RecordLectureScreenState
    extends State<RecordLectureScreen> {
  final SpeechToText _speech =
  SpeechToText();

  final HuggingFaceService _aiService =
  HuggingFaceService();

  bool _isListening = false;
  bool _isPaused = false;
  bool _isLoading = false;

  String _spokenText = "";
  String _summary = "";

  Timer? _timer;
  int _seconds = 0;

  //////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  //////////////////////////////////////////////////////////////

  Future<void> requestPermission() async {
    await Permission.microphone.request();
  }

  //////////////////////////////////////////////////////////////
  /// TIMER

  void startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        setState(() {
          _seconds++;
        });
      },
    );
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void resetTimer() {
    stopTimer();
    _seconds = 0;
  }

  String formatTime(int seconds) {
    final minutes =
        seconds ~/ 60;

    final secs =
        seconds % 60;

    return "${minutes.toString().padLeft(2, '0')}:"
        "${secs.toString().padLeft(2, '0')}";
  }

  //////////////////////////////////////////////////////////////
  /// START

  Future<void> startListening() async {
    bool available =
    await _speech.initialize();

    if (available) {
      setState(() {
        _isListening = true;
        _isPaused = false;
      });

      startTimer();

      _speech.listen(
        onResult: (result) {
          setState(() {
            _spokenText =
                result.recognizedWords;
          });
        },
      );
    }
  }

  //////////////////////////////////////////////////////////////
  /// PAUSE

  Future<void> pauseListening() async {
    await _speech.stop();

    setState(() {
      _isPaused = true;
      _isListening = false;
    });

    stopTimer();
  }

  //////////////////////////////////////////////////////////////
  /// STOP

  Future<void> stopListening() async {
    await _speech.stop();

    setState(() {
      _isListening = false;
      _isPaused = false;
    });

    stopTimer();
  }

  //////////////////////////////////////////////////////////////
  /// GENERATE SUMMARY

  Future<void> generateSummary() async {
    if (_spokenText.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
          Text("No speech detected"),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result =
      await _aiService
          .summarizeText(
        _spokenText,
      );

      setState(() {
        _summary = result;
        _isLoading = false;
      });

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
            const SummaryScreen(),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
              "Error: $e"),
        ),
      );
    }
  }

  //////////////////////////////////////////////////////////////

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  //////////////////////////////////////////////////////////////

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text("Record Lecture"),
        centerTitle: true,
      ),

      body: Padding(
        padding:
        const EdgeInsets.all(16),

        child: Column(
          children: [

            //////////////////////////////////////////////////////
            /// STATUS

            Text(
              _isListening
                  ? "Recording..."
                  : _isPaused
                  ? "Paused"
                  : "Ready to Record",
              style:
              const TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(
                height: 10),

            //////////////////////////////////////////////////////
            /// TIMER

            Text(
              formatTime(_seconds),
              style:
              const TextStyle(
                fontSize: 32,
                fontWeight:
                FontWeight.bold,
                color: Colors.red,
              ),
            ),

            const SizedBox(
                height: 30),

            //////////////////////////////////////////////////////
            /// BUTTONS

            Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .center,
              children: [

                //////////////////////////////////
                /// START

                FloatingActionButton(
                  heroTag: "start",
                  backgroundColor:
                  Colors.green,
                  onPressed:
                  _isListening
                      ? null
                      : startListening,
                  child:
                  const Icon(
                    Icons.mic,
                  ),
                ),

                const SizedBox(
                    width: 20),

                //////////////////////////////////
                /// PAUSE

                FloatingActionButton(
                  heroTag: "pause",
                  backgroundColor:
                  Colors.orange,
                  onPressed:
                  _isListening
                      ? pauseListening
                      : null,
                  child:
                  const Icon(
                    Icons.pause,
                  ),
                ),

                const SizedBox(
                    width: 20),

                //////////////////////////////////
                /// STOP

                FloatingActionButton(
                  heroTag: "stop",
                  backgroundColor:
                  Colors.red,
                  onPressed:
                  (_isListening ||
                      _isPaused)
                      ? stopListening
                      : null,
                  child:
                  const Icon(
                    Icons.stop,
                  ),
                ),
              ],
            ),

            const SizedBox(
                height: 30),

            //////////////////////////////////////////////////////
            /// SPEECH BOX

            Expanded(
              child: Container(
                width: double.infinity,
                padding:
                const EdgeInsets.all(
                    16),
                decoration:
                BoxDecoration(
                  color: Colors
                      .grey.shade100,
                  borderRadius:
                  BorderRadius
                      .circular(12),
                ),
                child:
                SingleChildScrollView(
                  child: Text(
                    _spokenText.isEmpty
                        ? "Your speech will appear here..."
                        : _spokenText,
                    style:
                    const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(
                height: 16),

            //////////////////////////////////////////////////////
            /// GENERATE BUTTON

            SizedBox(
              width: double.infinity,
              height: 52,
              child:
              ElevatedButton.icon(
                icon:
                const Icon(
                    Icons.auto_awesome),
                label:
                _isLoading
                    ? const Text(
                    "Generating...")
                    : const Text(
                    "Generate Summary"),
                onPressed:
                _isLoading
                    ? null
                    : generateSummary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}