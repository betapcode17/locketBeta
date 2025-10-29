class UserProfileModel {
  final String id;
  final String username; // e.g., "Hậu Ngọc"
  final String handle; // e.g., "dodoododo"
  final String profileImageUrl;
  final int locketCount;
  final int streak;

  UserProfileModel({
    required this.id,
    required this.username,
    required this.handle,
    required this.profileImageUrl,
    this.locketCount = 0,
    this.streak = 0,
  });
}