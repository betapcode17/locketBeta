class LocketPhotoModel {
  final String id; // Unique ID for the photo itself
  final String userId; // ID of the user who posted it
  final String imageUrl;
  final DateTime timestamp;

  LocketPhotoModel({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.timestamp,
  });
}
