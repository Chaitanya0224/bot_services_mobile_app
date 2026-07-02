import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class BotService {
  final String _apiUrl = "https://integrate.api.nvidia.com/v1/chat/completions";
  final String _apiKey = "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";

  final List<String> _fallbackJokes = [
    "Why don't scientists trust atoms? Because they make up everything!",
    "Why did the scarecrow win an award? Because he was outstanding in his field!",
    "Why don't skeletons fight each other? They don't have the guts.",
    "What do you call a fake noodle? An impasta!",
    "How does a penguin build its house? Igloos it together!"
  ];

  Future<String> getBotResponse(String userInput) async {
    // Inject system directive so the bot always responds like a funny/premium chatbot
    final systemPrompt = "You are Joke BOT, a premium, witty, and hilarious AI chatbot. Keep responses funny, concise (1-3 sentences), and suitable to be spoken out loud.";

    final Map<String, dynamic> payload = {
      "model": "minimaxai/minimax-m3",
      "messages": [
        {"role": "system", "content": systemPrompt},
        {"role": "user", "content": userInput}
      ],
      "max_tokens": 150,
      "temperature": 1.00,
      "top_p": 0.95,
      "stream": false,
    };

    print("------ Nvidia API Request ------");
    print("URL: $_apiUrl");
    print("Payload: ${jsonEncode(payload)}");

    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(payload),
      );

      stopwatch.stop();
      print("------ Nvidia API Response ------");
      print("Status Code: ${response.statusCode}");
      print("Response Time: ${stopwatch.elapsedMilliseconds} ms");
      print("Response Body: ${response.body}");
      print("---------------------------------");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String botMessage = data['choices'][0]['message']['content'];
        return botMessage.trim();
      } else {
        return _getRandomFallback();
      }
    } catch (e) {
      stopwatch.stop();
      print("------ Nvidia API Exception ------");
      print("Response Time: ${stopwatch.elapsedMilliseconds} ms");
      print("Exception: $e");
      print("----------------------------------");
      return _getRandomFallback();
    }
  }

  String _getRandomFallback() {
    return _fallbackJokes[Random().nextInt(_fallbackJokes.length)];
  }
}
