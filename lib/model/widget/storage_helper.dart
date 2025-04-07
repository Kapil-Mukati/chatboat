import 'dart:convert';
import 'package:mychatboat/model/message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const String _chatHistoryKey = 'chat_history';

  static Future<bool> saveChatHistory(List<Message> message) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonMessages =
          message.map((msg) => jsonEncode(msg.toJson())).toList();

      await prefs.setStringList(_chatHistoryKey, jsonMessages);
      return true;
    } catch (e) {
      print('Error occure during chat history saving: $e');
      return false;
    }
  }

  static Future<List<Message>> loadChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonMessages = prefs.getStringList(_chatHistoryKey) ?? [];
      return jsonMessages
          .map((jsonMsg) => Message.fromJson(jsonDecode(jsonMsg)))
          .toList();
    } catch (e) {
      print("Error loading chat history: $e");
      return [];
    }
  }

  static Future<bool> clearChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_chatHistoryKey);
      return true;
    } catch (e) {
      print('Error occure while clear chat History: $e');
      return false;
    }
  }
}
