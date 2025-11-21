import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/model/signup_model.dart';
import 'signup_state.dart';
import 'package:locket_beta/utils/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  final ApiClient _apiClient = ApiClient();

  Future<void> signup(SignupModel model) async {
    emit(SignupLoading());

    // Validate model before calling API
    if (!model.validateEmail()) {
      emit(const SignupFailure('Invalid Email.'));
      return;
    }
    if (!model.validatePassword()) {
      emit(const SignupFailure(
          'Password must contain at least an Uppercase and a Number.'));
      return;
    }

    try {
      final response = await _apiClient.dio.post(
        "/api/auth/register",
        data: {
          "username": model.username,
          "email": model.email,
          "password": model.password,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;

        // save token if backend return accessToken + refreshToken
        final prefs = await SharedPreferences.getInstance();
        if (data["accessToken"] != null) {
          model.accessToken = data["accessToken"];
          await prefs.setString("accessToken", data["accessToken"]);
        }
        if (data["refreshToken"] != null) {
          model.refreshToken = data["refreshToken"];
          await prefs.setString("refreshToken", data["refreshToken"]);
        }

        emit(SignupSuccess(model));
      } else {
        emit(SignupFailure(
            "Signup failed. Status code: ${response.statusCode}"));
      }
    } on DioException catch (e) {
      String errorMsg = "Signup Error";
      if (e.response != null && e.response?.data != null) {
        errorMsg = e.response?.data["message"] ?? errorMsg;
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMsg = "Connection Timeout";
      }
      emit(SignupFailure(errorMsg));
    } catch (e) {
      emit(SignupFailure("Unexpected Error: $e"));
    }
  }
}
