import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/model/login_model.dart';
import 'package:locket_beta/utils/api_client.dart';
import 'login_state.dart';
import "package:locket_beta/utils/local_storage.dart";
import "package:shared_preferences/shared_preferences.dart";

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final ApiClient _apiClient = ApiClient();

  Future<void> login(String email, String password) async {
    emit(LoginLoading());

    try {
      final response = await _apiClient.dio.post(
        "/api/auth/login",
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final userId = data["user"]["id"];

        final user = LoginModel(
          email: data["user"]["email"],
          password: password,
          token: data["accessToken"],
          showPassword: false,
          userId: userId,
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("accessToken", data["accessToken"]);
        await prefs.setString("refreshToken", data["refreshToken"] ?? "");

        if (userId != null) {
          await LocalStorage.saveUserId(userId);
        }

        emit(LoginSuccess(user));
      } else {
        emit(LoginFailure("Login Failed, status: ${response.statusCode}"));
      }
    } catch (e) {
      emit(LoginFailure("Login Error: $e"));
    }
  }
}
  // Future<void> login(String email, String password) async {
  //   emit(LoginLoading());

  //   await Future.delayed(const Duration(seconds: 2));

  //   if (email == 'locket@gmail.com' && password == 'Password123') {
  //     final user = LoginModel(
  //         //token: 'fake_token_123',
  //         email: "locket@gmail.com",
  //         password: "Password123",
  //         showPassword: false);
  //     emit(LoginSuccess(user));
  //   } else {
  //     emit(const LoginFailure('Incorrect Email or Password'));
  //   }
  // }

