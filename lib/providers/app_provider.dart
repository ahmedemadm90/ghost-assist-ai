import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/ai_service.dart';

class AppProvider extends ChangeNotifier {
  String _apiKey = '';
  bool _isListening = false;
  bool _isGhostMode = false;
  String _currentQuestion = '';
  String _aiResponse = '';
  String _meetingContext = 'Software Engineering Interview';
  final List<Map<String, String>> _notes = [];

  String get apiKey => _apiKey;
  bool get isListening => _isListening;
  bool get isGhostMode => _isGhostMode;
  String get currentQuestion => _currentQuestion;
  String get aiResponse => _aiResponse;
  String get meetingContext => _meetingContext;
  List<Map<String, String>> get notes => _notes;

  late AIService _aiService;

  AppProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _apiKey = prefs.getString('openai_api_key') ?? '';
    _meetingContext = prefs.getString('meeting_context') ?? 'Software Engineering Interview';
    _aiService = AIService(apiKey: _apiKey);
    notifyListeners();
  }

  Future<void> setApiKey(String key) async {
    _apiKey = key;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('openai_api_key', key);
    _aiService = AIService(apiKey: key);
    notifyListeners();
  }

  Future<void> setContext(String context) async {
    _meetingContext = context;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('meeting_context', context);
    notifyListeners();
  }

  void toggleGhostMode() {
    _isGhostMode = !_isGhostMode;
    notifyListeners();
  }

  void toggleListening() {
    _isListening = !_isListening;
    notifyListeners();
  }

  Future<void> askAI(String question) async {
    _currentQuestion = question;
    _aiResponse = 'Thinking... (AI is analyzing the question)';
    notifyListeners();

    _aiResponse = await _aiService.generateInterviewAnswer(question, _meetingContext);
    
    // Add to notes automatically
    _notes.add({
      'question': question,
      'answer': _aiResponse,
      'time': DateTime.now().toString().substring(11, 16),
    });

    notifyListeners();
  }

  void clearNotes() {
    _notes.clear();
    notifyListeners();
  }
}
