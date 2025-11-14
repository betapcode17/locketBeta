// class MessageModel {
//   final String text;
//   final bool isMe;
//   final DateTime time;
//   MessageModel({required this.text, required this.isMe, required this.time});
// }

class MessageModel {
  final String? id;
  final String? chatId;
  final String senderId;
  final String content;
  final String type; // 'text' | 'image'
  final DateTime createdAt;
  final bool isMe;

  MessageModel({
    this.id,
    this.chatId,
    required this.senderId,
    required this.content,
    this.type = 'text',
    required this.createdAt,
    required this.isMe,
  });

  // JSON từ server -> MessageModel
  // truyền currentUserId để tự động set isMe
  factory MessageModel.fromJson(Map<String, dynamic> json, {String? currentUserId}) {
    final dynamic senderField = json['sender'];
    final String senderId = senderField is String
        ? senderField
        : (senderField?['_id'] ?? senderField?['id'])?.toString() ?? '';

    final DateTime created = json['createdAt'] != null
        ? DateTime.parse(json['createdAt']).toLocal()
        : DateTime.now();

    final bool isMe = currentUserId != null
        ? senderId == currentUserId
        : (json['isMe'] as bool?) ?? false;

    return MessageModel(
      id: (json['_id'] ?? json['id'])?.toString(),
      chatId: json['chatId']?.toString(),
      senderId: senderId,
      content: (json['content'] ?? '').toString(),
      type: (json['type'] ?? 'text').toString(),
      createdAt: created,
      isMe: isMe,
    );
  }

  // Gửi lên server
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (chatId != null) 'chatId': chatId,
      'sender': senderId,
      'content': content,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}