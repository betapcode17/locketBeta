class Friend {
  final String id;
  final String name;
  final String? profileImage;
  final bool isActive;
  final DateTime lastSeen;

  Friend({
    required this.id,
    required this.name,
    this.profileImage,
    required this.isActive,
    required this.lastSeen,
  });

  Friend copyWith({
    String? id,
    String? name,
    String? profileImage,
    bool? isActive,
    DateTime? lastSeen,
  }) {
    return Friend(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      isActive: isActive ?? this.isActive,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  // alias getter for older code expecting `isOnline`
  bool get isOnline => isActive;

  factory Friend.fromJson(Map<String, dynamic> json) {
    final dynamic activeValue = json['isActive'] ?? json['isOnline'] ?? false;
    final bool active = activeValue is bool
        ? activeValue
        : (activeValue.toString().toLowerCase() == 'true');

    return Friend(
      id: json['id'] as String,
      name: json['name'] as String,
      profileImage: json['profileImage'] as String?,
      isActive: active,
      lastSeen: DateTime.parse(json['lastSeen'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileImage': profileImage,
      'isActive': isActive,
      'lastSeen': lastSeen.toIso8601String(),
    };
  }
}
