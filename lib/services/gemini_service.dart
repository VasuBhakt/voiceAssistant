import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:voice_assistant/secrets.dart';

class GeminiService {
  Future<String> geminiAPI(List<Map<String, dynamic>> messages) async {
    try {
      final res = await http.post(
        Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent",
        ),
        headers: {
          "x-goog-api-key": GEMINI_API_KEY,
          "Content-Type": "application/json",
        },
        body: jsonEncode({"contents": messages}),
      );
      String content = jsonDecode(
        res.body,
      )['candidates'][0]['content']['parts'][0]['text'];

      // Remove markdown formatting very fast
      content = content
          .replaceAll(RegExp(r'\*{1,3}(.*?)\*{1,3}'),'',) // *bold*, **bold**, ***bold***
          .replaceAll(RegExp(r'#{1,6}\s*'), '') // markdown headings #####
          .replaceAll(RegExp(r'`{1,3}(.*?)`{1,3}'), '') // inline code
          .trim();

      return content;
    } catch (e) {
      return e.toString();
    }
  }
}
