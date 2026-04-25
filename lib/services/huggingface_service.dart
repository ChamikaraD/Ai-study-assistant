import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HuggingFaceService {
  final String _apiKey = dotenv.env['HF_API_KEY'] ?? "";

  /// Model endpoint
  final String _url =
      "https://router.huggingface.co/hf-inference/models/google/flan-t5-large";

  /// =========================
  /// ASK AI
  /// =========================
  Future<String> askQuestion(String question) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "inputs": question,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List && data.isNotEmpty) {
          return data[0]["generated_text"] ?? "No response";
        }

        return "Empty response";
      }

      return "API Error: ${response.body}";
    } catch (e) {
      return "Failed to get response";
    }
  }

  /// =========================
  /// SUMMARIZE TEXT
  /// =========================
  Future<String> summarizeText(String text) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "inputs": "Summarize this text: $text",
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List && data.isNotEmpty) {
          return data[0]["generated_text"] ?? "No summary";
        }

        return "Empty summary";
      }

      return "API Error: ${response.body}";
    } catch (e) {
      return "Failed to summarize";
    }
  }
}