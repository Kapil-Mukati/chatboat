import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mychatboat/model/message_model.dart';
import 'package:mychatboat/model/widget/chat_Input_box.dart';
import 'package:mychatboat/model/widget/chat_data.dart';
import 'package:mychatboat/model/widget/message_bubble.dart';
import 'package:mychatboat/model/widget/storage_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatboat',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: Colors.purple,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool isLoading = true;
  Timer? typingTimer;
  bool isBotTyping = false;

  final Set<int> _animatedMessage = {};

  @override
  void initState() {
    super.initState();
    _loadMessage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    typingTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadMessage() async {
    setState(() {
      isLoading = true;
    });

    final savedMessage = await StorageHelper.loadChatHistory();
    setState(() {
      if (savedMessage.isEmpty) {
        _messages.add(
          Message(
            text:
                "Hello! I'm your fitness assistant. How can I help you today?",
            isUser: false,
          ),
        );
      } else {
        _messages.addAll(savedMessage);
      }
      isLoading = false;
    });

    if (savedMessage.isEmpty) {
      StorageHelper.saveChatHistory(_messages);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSendMessage(String text) {
    if (text.trim().isEmpty) return;

    // add User Message
    final userMessage = Message(
      text: text,
      isUser: true,
    );

    setState(() {
      _messages.add(userMessage);
      isBotTyping = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    StorageHelper.saveChatHistory(_messages);

    typingTimer = Timer(const Duration(milliseconds: 500), () {
      final botResponse = ChatbotResponse.getResponse(text);

      final botMessage = Message(
        text: botResponse,
        isUser: false,
      );

      setState(() {
        isBotTyping = false;
        _messages.add(botMessage);
        _animatedMessage.add(_messages.length - 1);
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });

      StorageHelper.saveChatHistory(_messages);
    });
  }

  void clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text("Are you sure you want to clear the chat history?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              confirmCleanChat();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void confirmCleanChat() async {
    setState(() {
      isLoading = true;
    });

    await StorageHelper.clearChatHistory();

    setState(() {
      _messages.clear();
      _messages.add(Message(
        text: "Hello! I'm your fitness assistant. How can I help you today?",
        isUser: false,
      ));
      isLoading = false;
    });

    StorageHelper.saveChatHistory(_messages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Assistant'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
            onPressed: clearChat,
            tooltip: 'Clear Chat',
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: SpinKitPulse(
                color: Theme.of(context).primaryColor,
                size: 50.0,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    itemCount: _messages.length + (isBotTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && isBotTyping) {
                        return MessageBubble(
                          message: Message(
                            text: 'Typing...',
                            isUser: false,
                            timeStamp: DateTime.now(),
                            isTyping: true,
                          ),
                        );
                      }

                      final message = _messages[index];
                      final showTypingAnimation =
                          _animatedMessage.contains(index);

                      if (showTypingAnimation) {
                        _animatedMessage.remove(index);
                      }

                      return MessageBubble(
                        message: message,
                        showTypingAnimation: showTypingAnimation,
                      );
                    },
                  ),
                ),
                ChatInput(onSendMessage: _handleSendMessage)
              ],
            ),
    );
  }
}
