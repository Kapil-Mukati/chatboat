class Message {
  final String text;
  final bool isUser;
  final DateTime? timeStamp;
  final bool isTyping;

  Message({
    required this.text,
    required this.isUser,
    this.timeStamp,
    this.isTyping = false,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "text": text,
      "isUser": isUser,
      "isTyping": isTyping,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'],
      isUser: json['isUser'],
      timeStamp: DateTime.parse(json['timeStamp']),
      isTyping: json['isTyping'] ?? false,
    );
  }
}
