import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:locket_beta/model/photo_model.dart';
import 'package:locket_beta/photo/cubit/photo_state.dart'; // Reuse PhotoModel from photo
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  static const String baseUrl = 'http://10.0.2.2:5001/api';
  late final Dio _dio;

  HistoryCubit() : super(HistoryInitial()) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) => status! < 500,
    ));

    // Log interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('📤 Dio Request: ${options.method} ${options.path}');
        print('Headers: ${options.headers}');
        print('Body: ${options.data}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('📥 Dio Response: ${response.statusCode}');
        print('Data: ${response.data}');
        handler.next(response);
      },
      onError: (error, handler) {
        print('❌ Dio Error type: ${error.type}');
        print('Message: ${error.message}');
        if (error.response != null) {
          print('Server status: ${error.response?.statusCode}');
          print('Server data: ${error.response?.data}');
        }
        handler.next(error);
      },
    ));
  }

  // Fetch all photos from API (no params, as per backend)
  Future<void> fetchPhotos() async {
    emit(HistoryLoading());
    try {
      final response = await _dio.get('/photos');

      if (response.statusCode == 200) {
        final data = response.data;
        print(data);
        final List<dynamic> photosJson = data['photos'] ?? [];
        final photos =
            photosJson.map((json) => PhotoModel.fromJson(json)).toList();
        emit(HistoryLoaded(photos));
      } else {
        throw Exception(
            'Fetch failed: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      print('❌ Fetch Dio error: ${e.message}');
      emit(HistoryError('Không thể lấy ảnh: ${e.message}'));
    } catch (e) {
      print('❌ Fetch error: $e');
      emit(HistoryError("Không thể lấy ảnh: $e"));
    }
  }

  void deletePhoto(String id) {}
}
