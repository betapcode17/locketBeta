import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/model/signup_model.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  Future<void> signup(SignupModel model) async {
    emit(SignupLoading());

    if (!model.email.contains('@')) {
      emit(const SignupFailure('Invalid Email.'));
      return;
    }
    if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)').hasMatch(model.password)) {
      emit(const SignupFailure(
          'Password must contain at least a Uppercase and a Number.'));
      return;
    }

    await Future.delayed(const Duration(seconds: 2));

    emit(SignupSuccess(model));
  }
}
