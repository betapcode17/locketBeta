class FriendRequest {
  final String id;
  final String senderId;
  final String name;
  final String? profileImage;

  FriendRequest({
    required this.id,
    required this.senderId,
    required this.name,
    this.profileImage,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      name: json['name'] as String? ?? 'Unknown',
      profileImage: json['profileImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'name': name,
        'profileImage': profileImage,
      };
}
