import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HFAiService {
  final String _apiKey = dotenv.env['HF_API_KEY'] ?? "";

  final String _modelUrl =
      "https://api-inference.huggingface.co/models/facebook/bart-large-cnn";

  Future<String> summarizeText(String text) async {
    final response = await http.post(
      Uri.parse(_modelUrl),
      headers: {
        "Authorization": "Bearer $_apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "inputs": text,
        "parameters": {
          "max_length": 150,
          "min_length": 40,
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data[0]["summary_text"];
    } else {
      return "Error: ${response.body}";
    }
  }
}