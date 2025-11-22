class LoginModel {
  //final String token;
  final String email;
  final String password;
  final String? token;
  bool showPassword;

  LoginModel(
      {
      //required this.token,
      required this.email,
      required this.password,
      this.token,
      required this.showPassword,
      required userId});

  // factory LoginModel.fromJson(Map<String, dynamic> json) {
  //   return LoginModel(
  //     //token: json['token'] ?? '',
  //     email: json['email'] ?? '',
  //     password: json['password'] ?? '',
  //   );
  // }
}
