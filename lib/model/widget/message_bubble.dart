import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import '../message_model.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool showTypingAnimation;

  const MessageBubble({
    super.key,
    required this.message,
    this.showTypingAnimation = false,
  });

  @override
  Widget build(BuildContext context) {
    if (message.isUser) {
      log('User Type Message..');
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 16.0,
      ),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) _buildAvatar(),
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                      color: message.isUser
                          ? Colors.purple.shade600
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(18.0).copyWith(
                        bottomRight: message.isUser
                            ? const Radius.circular(0)
                            : const Radius.circular(18.0),
                        bottomLeft: !message.isUser
                            ? const Radius.circular(0)
                            : const Radius.circular(18.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ]),
                  child: _buildMessageContent(),
                ),
              ],
            ),
          ),
          if (message.isUser) _buildAvatar(),
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    if (message.isTyping) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultTextStyle(
            style: TextStyle(
              color: message.isUser ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText('Typing...'),
              ],
              isRepeatingAnimation: true,
              repeatForever: true,
            ),
          ),
        ],
      );
    } else if (showTypingAnimation && !message.isUser) {
      return DefaultTextStyle(
        style: TextStyle(
          fontSize: 16.0,
          color: message.isUser ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w400,
        ),
        child: AnimatedTextKit(
          animatedTexts: [
            CustomTypewriterText(
              message.text,
              speed: const Duration(milliseconds: 40),
            )
          ],
          totalRepeatCount: 1,
          displayFullTextOnTap: true,
        ),
      );
    } else {
      return Text(
        message.text,
        style: TextStyle(
          fontSize: 16.0,
          color: message.isUser ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w400,
        ),
      );
    }
  }

  Widget _buildAvatar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, left: 4.0, right: 4.0),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: message.isUser ? Colors.blue.shade700 : Colors.green,
        child: Icon(
          message.isUser ? Icons.person : Icons.fitness_center,
          size: 16.0,
        ),
      ),
    );
  }
}

class CustomTypewriterText extends AnimatedText {
  final Duration speed;
  final String cursor;

  CustomTypewriterText(
    String text, {
    required this.speed,
    this.cursor = '',
    TextAlign textAlign = TextAlign.start,
    TextStyle? textStyle,
  }) : super(
          text: text,
          textAlign: textAlign,
          textStyle: textStyle,
          duration: speed * (text.characters.length + 4),
        );

  late Animation<double> _typewriterText;
  late Animation<int> _dotsAnimation;

  @override
  void initAnimation(AnimationController controller) {
    _typewriterText = Tween<double>(
      begin: 0,
      end: text.characters.length.toDouble(),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(
        0,
        text.isEmpty ? 1.0 : 0.9,
        curve: Curves.linear,
      ),
    ));

    _dotsAnimation = IntTween(
      begin: 0,
      end: 3,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(
        0.9,
        1.0,
        curve: Curves.easeIn,
      ),
    ));
  }

  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    final textLength = _typewriterText.value.floor();
    String displayText = "";

    if (textLength < text.characters.length) {
      displayText = text.substring(0, textLength);
    } else {
      displayText = text;
    }

    if (_dotsAnimation.value > 0 && textLength < text.characters.length) {
      String dots = '';
      for (int i = 0; i < _dotsAnimation.value; i++) {
        dots += '.';
      }
      displayText += dots;
    }

    return Text(
      displayText,
      style: textStyle,
      textAlign: textAlign,
    );
  }

  Animation<double> get opacity => kAlwaysCompleteAnimation;
}
