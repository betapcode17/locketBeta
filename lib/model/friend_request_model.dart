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
      id: json['id']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
      profileImage: json['profileImage']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'name': name,
        'profileImage': profileImage,
      };
}
