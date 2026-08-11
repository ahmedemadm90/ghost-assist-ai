import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  final String apiKey;

  AIService({required this.apiKey});

  Future<String> generateInterviewAnswer(String question, String context) async {
    if (apiKey.isEmpty) {
      return "⚠️ Please provide your OpenAI API Key in settings to get real-time AI assistance.";
    }

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'system',
              'content': 'You are an expert invisible interview and meeting assistant. Given a question or discussion point, provide a concise, highly professional, structured answer or talking points that the user can immediately say or use. Keep it direct and impactful.'
            },
            {
              'role': 'user',
              'content': 'Context: $context\n\nQuestion/Point: $question'
            }
          ],
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return 'Error communicating with OpenAI API: ${response.statusCode}';
      }
    } catch (e) {
      return 'Exception occurred: $e';
    }
  }

  Future<String> summarizeMeeting(String transcripts) async {
    if (apiKey.isEmpty) return "⚠️ API Key missing.";

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'system',
              'content': 'Summarize the following meeting transcript into professional action items, key decisions, and main discussion points.'
            },
            {
              'role': 'user',
              'content': transcripts
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      }
    } catch (e) {
      return 'Error: $e';
    }
    return 'Failed to generate summary.';
  }
}
