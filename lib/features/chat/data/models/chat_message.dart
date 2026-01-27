class ChatMessage {
  final String id;
  final String content;
  final String type;
  final DateTime createdAt;
  final ChatSender sender;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.sender,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'] as String? ?? '',
      content: json['content'] as String? ?? '',
      type: json['type'] as String? ?? 'message',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      sender: ChatSender.fromJson(json['sender'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class ChatSender {
  final String id;
  final String? avatar;
  final String? name;

  const ChatSender({
    required this.id,
    this.avatar,
    this.name,
  });

  factory ChatSender.fromJson(Map<String, dynamic> json) {
    return ChatSender(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      avatar: json['avatar'] as String?,
      name: json['name'] as String?,
    );
  }
}


