import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HuggingFaceService {
  final String _apiKey = dotenv.env['HF_API_KEY']!;

  Future<String> summarizeText(String text) async {
    final url = Uri.parse(
      "https://router.huggingface.co/hf-inference/models/facebook/bart-large-cnn",
    );

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $_apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "inputs": text,
        "parameters": {
          "max_length": 130,
          "min_length": 30,
          "do_sample": false
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data[0]['summary_text'];
    } else {
      throw Exception("Error: ${response.body}");
    }
  }
}