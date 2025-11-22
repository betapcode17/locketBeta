class PhotoModel {
  final String id;
  final String userId;
  final String imageUrl;
  final DateTime timestamp;
  final String? caption;

  PhotoModel({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.timestamp,
    this.caption,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      timestamp:
          DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      caption: json['caption'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'imageUrl': imageUrl,
      'timestamp': timestamp.toIso8601String(),
      'caption': caption,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PhotoModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
