import 'package:speech_to_text/speech_to_text.dart' as stt;

class SttService {
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  Future<bool> initialize() async {
    try {
      return await _speechToText.initialize(
        onError: (val) => print('Speech Error: $val'),
        onStatus: (val) => print('Speech Status: $val'),
      );
    } catch (e) {
      print('Speech Init Exception: $e');
      return false;
    }
  }

  void listen({
    required Function(String) onResult,
    required Function(bool) onListeningStateChanged,
  }) async {
    bool available = await initialize();
    if (available) {
      onListeningStateChanged(true);
      _speechToText.listen(
        onResult: (val) {
          onResult(val.recognizedWords);
        },
      );
    }
  }

  void stop(Function(bool) onListeningStateChanged) {
    _speechToText.stop();
    onListeningStateChanged(false);
  }
}
