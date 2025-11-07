class SignupModel {
  final String username;
  final String email;
  final String password;

  bool emailInvalid;
  bool passwordInvalid;

  SignupModel({
    required this.username,
    required this.email,
    required this.password,
    this.emailInvalid = false,
    this.passwordInvalid = false,
  });

  bool validateEmail() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    emailInvalid = !emailRegex.hasMatch(email);
    return !emailInvalid;
  }

  bool validatePassword() {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    passwordInvalid = !(hasUppercase && hasNumber);
    return !passwordInvalid;
  }

  bool isValid() {
    return validateEmail() && validatePassword();
  }
}
