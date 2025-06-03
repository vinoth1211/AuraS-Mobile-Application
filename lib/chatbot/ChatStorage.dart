import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ChatStorage {
  static const String _chatHistoryKey = 'chatHistory';

  static Future<void> saveConversation(Map<String, dynamic> conversation) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getChatHistory();
    history.add(conversation);
    await prefs.setStringList(_chatHistoryKey, history.map((c) => jsonEncode(c)).toList());
  }

  static Future<List<Map<String, dynamic>>> getChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_chatHistoryKey) ?? [];
    return historyJson.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chatHistoryKey);
  }

  static String getCurrentDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  static String getCurrentTime() {
    return DateFormat('HH:mm').format(DateTime.now());
  }
}