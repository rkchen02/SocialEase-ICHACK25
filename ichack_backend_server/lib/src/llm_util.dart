import 'package:serverpod/serverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dotenv/dotenv.dart';

abstract final class LLMUtil {
  // The base URL for Claude API
  static const String _apiUrl = 'https://api.anthropic.com/v1/messages';
  // static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  static String buildReq(String prompt) {
    // return jsonEncode({
    //   "model": "gpt-4o-mini",
    //   "store": true,
    //   "messages": [
    //     {"role": "user", "content": prompt}
    //   ]
    // });

    // other options: https://www.anthropic.com/pricing#anthropic-api
    // Claude 3 Haiku Legacy model (cheapest)
    return jsonEncode({
      'model': 'claude-3-haiku-20240307',
      'max_tokens': 1024,
      'messages': [
        {
          'role': 'user',
          'content': prompt,
        }
      ],
    });
  }

  static Future<String> ask(Session session, String prompt) async {
    try {
      // Get API key from environment or configuration
      // Expects .env in root
      var env = DotEnv(includePlatformEnvironment: true)..load();
      final apiKey = env['CLAUDE_API_KEY'];
      // final apiKey = env['OPENAI_API_KEY'];

      if (apiKey == null) {
        throw Exception('CLAUDE_API_KEY not found in configuration');
      }

      // Prepare the request headers
      final headers = {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
      };
      // 'Authorization': 'Bearer $apiKey'

      // Prepare the request body
      final String body = buildReq(prompt);

      // Make the API request
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: headers,
        body: body,
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['content'][0]['text'];
      } else {
        // Handle error responses
        throw Exception(
            'Failed to get response from Claude API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Log the error and rethrow with a user-friendly message
      // session.log.error('Error in LLMEndpoint.ask: $e');
      throw Exception('Failed to process request: $e');
    }
  }
}
