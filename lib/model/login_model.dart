class LoginModel {
  //final String token;
  final String email;
  final String password;
  bool showPassword;

  LoginModel(
      {
      //required this.token,
      required this.email,
      required this.password,
      required this.showPassword});

  // factory LoginModel.fromJson(Map<String, dynamic> json) {
  //   return LoginModel(
  //     //token: json['token'] ?? '',
  //     email: json['email'] ?? '',
  //     password: json['password'] ?? '',
  //   );
  // }
}
