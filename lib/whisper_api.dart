import 'dart:convert'; //encoding and decosing JSON
import 'package:http/http.dart' as http; // http req

class WhisperAPI {
  static const String _baseUrl =
      'https://api.openai.com/v1/audio/transcriptions'; // Replacing with (base URL) Whisper API endpoint
  static String _apiKey = '';

  static Future<String> generateResponse(String audioUrl) async {
    //returns a future string
    _apiKey = loadingApiKey();

    final Map<String, String> headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json', //content type converted to JSON
    };

    final Map<String, dynamic> data = {
      //data being sent to the API
      'audio_url': audioUrl,
      'model': 'whisper-1'
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(_baseUrl), //string to a Uri object
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // 200 = ok
        return jsonDecode(response.body)['transcript'];
      } else {
        throw Exception('Failed to generate response: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to generate response: $e');
    }
  }

  //basically getter
  static String loadingApiKey() {
    // for loading API key from environment variable
    return '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'; // I have to replace with our Whisper key
  }
}
