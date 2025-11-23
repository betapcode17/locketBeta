import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locket_beta/utils/api_client.dart';
import 'package:dio/dio.dart';

part 'edit_field_state.dart';

class EditFieldCubit extends Cubit<EditFieldState> {
  EditFieldCubit() : super(EditFieldInitial());

  final dio = ApiClient().dio;

  Future<void> updateField(Map<String, dynamic> data) async {
    try {
      emit(EditFieldLoading());
      await dio.put("/api/users/profile", data: data);
      print("UPDATE FIELD SUCCESS: $data");
      emit(EditFieldSuccess());
    } catch (e) {
      emit(EditFieldError(e.toString()));
    }
  }

  Future<void> updateAvatar(FormData formData) async {
    try {
      emit(EditFieldLoading());
      await dio.put("/api/users/profile", data: formData);
      print("UPDATE AVATAR SUCCESS: $formData");
      emit(EditFieldSuccess());
    } catch (e) {
      emit(EditFieldError(e.toString()));
    }
  }
}
