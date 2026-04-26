import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {
  //////////////////////////////////////////////////////////////
  /// API CONFIG

  final String _apiKey =
      dotenv.env['OPENAI_API_KEY'] ?? "";

  final String _url =
      "https://api.openai.com/v1/chat/completions";

  //////////////////////////////////////////////////////////////
  /// CORE REQUEST METHOD

  Future<String> _sendRequest({
    required List<Map<String, String>> messages,
    double temperature = 0.7,
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
          "messages": messages,
          "temperature": temperature,
        }),
      );

      if (response.statusCode == 200) {
        final data =
        jsonDecode(response.body);

        return data["choices"][0]["message"]
        ["content"];
      }

      return "API Error: ${response.body}";
    } catch (e) {
      return "Failed to get response";
    }
  }

  //////////////////////////////////////////////////////////////
  /// COMPATIBILITY METHOD (IMPORTANT FIX)

  /// This keeps your existing Ask AI screen working

  Future<String> askQuestion({
    required String question,
    required String systemPrompt,
  }) async {
    return await _sendRequest(
      messages: [
        {
          "role": "system",
          "content": systemPrompt,
        },
        {
          "role": "user",
          "content": question,
        }
      ],
    );
  }

  //////////////////////////////////////////////////////////////
  /// GENERAL AI

  Future<String> askGeneralQuestion(
      String question) async {
    return await _sendRequest(
      messages: [
        {
          "role": "system",
          "content":
          "You are a helpful AI assistant."
        },
        {
          "role": "user",
          "content": question
        }
      ],
    );
  }

  //////////////////////////////////////////////////////////////
  /// EDUCATION AI

  Future<String> askEducationQuestion(
      String question) async {
    return await _sendRequest(
      messages: [
        {
          "role": "system",
          "content":
          "You are an educational AI tutor. "
              "Answer only study-related questions "
              "clearly and simply for students."
        },
        {
          "role": "user",
          "content": question
        }
      ],
    );
  }

  //////////////////////////////////////////////////////////////
  /// SUMMARY GENERATION

  Future<String> summarizeText(
      String text) async {
    return await _sendRequest(
      messages: [
        {
          "role": "system",
          "content":
          "Summarize the following text into "
              "clear concise study notes."
        },
        {
          "role": "user",
          "content": text
        }
      ],
      temperature: 0.5,
    );
  }

  //////////////////////////////////////////////////////////////
  /// QUIZ GENERATION

  Future<List<Map<String, dynamic>>>
  generateQuiz(String summary) async {
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
              "content":
              "Generate 5 multiple choice questions "
                  "from the summary. "
                  "Return JSON format like this: "
                  "[{"
                  "question: '',"
                  "options: ['A','B','C','D'],"
                  "correctAnswer: ''"
                  "}]"
            },
            {
              "role": "user",
              "content": summary
            }
          ],
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data =
        jsonDecode(response.body);

        final content =
        data["choices"][0]["message"]
        ["content"];

        return List<Map<String, dynamic>>
            .from(jsonDecode(content));
      }

      return [];
    } catch (e) {
      return [];
    }
  }
}