import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notility/server/chatgpt.dart';

class ChatGPTAPI {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  static final String _apiKey = token; // Initialize thru API key
  // This key is a group key, all of us can use it. i made an account for all of us.

  // ----------------- Creds to login on OpenAi -------------------
  // usman.arshid.04@gmail.com
  // NotilityRocks1

  // Method to generate response
  static Future<String> generateResponse(String prompt) async {
    if (_apiKey.isEmpty) {
      throw Exception('API key is not set. use the "setApiKey".');
    }

    final Map<String, String> headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> data = // key value pairs of data
    {
      'model':'gpt-3.5-turbo', 
      'prompt': prompt, // starting point of response

      'max_tokens': 50, // maximum number of tokens the model can generate in the response
      //max_tokens (can be adjusted)

      'temperature': 0.7, //  randomness of the generated response (can be adjusted)
      'stop': '\n' // Stop token to end the response
    };

    final http.Response response = await http.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['choices'][0]['text']; // selecting the first choice (accessing value associated with this) --> [0]
    } // and extracting the "text" of the first choice
    else {
      throw Exception('Failed to generate response: ${response.statusCode}');
    }
  }
}
