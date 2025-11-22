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

    final String id = json['id']?.toString() ?? '';
    final String name = json['name']?.toString() ?? 'Unknown';
    final String lastSeenStr =
        json['lastSeen']?.toString() ?? DateTime.now().toIso8601String();

    return Friend(
      id: id,
      name: name,
      profileImage: json['profileImage']?.toString(),
      isActive: active,
      lastSeen: DateTime.tryParse(lastSeenStr) ?? DateTime.now(),
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
