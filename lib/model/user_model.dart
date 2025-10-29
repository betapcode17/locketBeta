class UserModel {
  String username;
  String imagePath;
  bool isActive;

  UserModel({
    required this.username,
    this.imagePath = 'assets/images/defaultUser.png',
    this.isActive = false,
  });

  UserModel copyWith({
    String? username,
    String? imagePath,
    bool? isActive
  }) {
    return UserModel(
      username: username ?? this.username,
      imagePath: imagePath ?? this.imagePath,
      isActive: isActive ?? this.isActive
    );
  }
}