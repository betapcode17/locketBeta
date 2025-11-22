import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/logout/cubit/logout_state.dart';
import 'package:locket_beta/utils/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());

    try {
      final prefs = await SharedPreferences.getInstance();

      // delete access token and refresh token
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');

      // delete userId from local storage
      await LocalStorage.removeUserId();

      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure('Logout failed: $e'));
    }
  }
}
