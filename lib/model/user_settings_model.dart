class UserSettingsModel {
  final String birthday;
  final String name;
  final String profilePhotoUrl;
  final String phoneNumber;
  final String? emailAddress;
  final String? musicProvider;
  final bool sendReadReceipts;
  
  UserSettingsModel({
    required this.birthday,
    required this.name,
    required this.profilePhotoUrl,
    required this.phoneNumber,
    this.emailAddress,
    this.musicProvider,
    this.sendReadReceipts = true,
  });

  UserSettingsModel copyWith({
    String? birthday,
    String? name,
    String? profilePhotoUrl,
    String? phoneNumber,
    String? emailAddress,
    String? musicProvider,
    bool? sendReadReceipts,
  }) {
    return UserSettingsModel(
      birthday: birthday ?? this.birthday,
      name: name ?? this.name,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailAddress: emailAddress ?? this.emailAddress,
      musicProvider: musicProvider ?? this.musicProvider,
      sendReadReceipts: sendReadReceipts ?? this.sendReadReceipts,
    );
  }
}