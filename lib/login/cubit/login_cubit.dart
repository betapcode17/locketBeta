import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/model/login_model.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());

    await Future.delayed(const Duration(seconds: 2));

    if (email == 'locket@gmail.com' && password == 'Password123') {
      final user = LoginModel(
          //token: 'fake_token_123',
          email: "locket@gmail.com",
          password: "Password123",
          showPassword: false);
      emit(LoginSuccess(user));
    } else {
      emit(const LoginFailure('Incorrect Email or Password'));
    }
  }
}
