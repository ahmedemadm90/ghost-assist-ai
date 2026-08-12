import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isAvailable = false;

  bool get isAvailable => _isAvailable;

  Future<bool> init() async {
    try {
      _isAvailable = await _speech.initialize(
        onError: (error) => print('Speech error: $error'),
        onStatus: (status) => print('Speech status: $status'),
      );
    } catch (e) {
      _isAvailable = false;
    }
    return _isAvailable;
  }

  Future<void> startListening(Function(String text) onResult) async {
    if (!_isAvailable) {
      bool available = await init();
      if (!available) return;
    }

    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      localeId: 'en_US', // Can support ar_SA or en_US
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  bool get isListening => _speech.isListening;
}
