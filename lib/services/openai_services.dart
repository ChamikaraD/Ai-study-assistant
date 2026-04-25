import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {
  final String _apiKey = dotenv.env['OPENAI_API_KEY'] ?? "";

  final String _url =
      "https://api.openai.com/v1/chat/completions";

  Future<String> askQuestion({
    required String question,
    required String systemPrompt,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "messages": [
            {
              "role": "system",
              "content": systemPrompt,
            },
            {
              "role": "user",
              "content": question,
            }
          ],
          "temperature": 0.7
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data["choices"][0]["message"]["content"];
      }

      return "API Error: ${response.body}";
    } catch (e) {
      return "Failed to get response";
    }
  }
}