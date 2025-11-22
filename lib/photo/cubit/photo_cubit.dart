import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:locket_beta/model/photo_model.dart';
import 'package:locket_beta/photo/cubit/photo_state.dart';

class PhotoCubit extends Cubit<PhotoState> {
  static const String baseUrl =
      'http://10.0.2.2:8000/api'; // FIX: Port 5001, emulator IP (device: IP máy:5001)
  late final Dio _dio;

  PhotoCubit() : super(PhotoInitial()) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'}, // JSON only
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

  // CREATE: POST JSON (FIX: plain Map, no FormData)
  Future<void> uploadPhoto({
    required String imageUrl,
    required String userId,
    String? caption,
  }) async {
    emit(PhotoUploading()); // Emit loading
    try {
      print('🔄 Cubit upload: userId=$userId, imageUrl=$imageUrl');
      final response = await _dio.post(
        '/photos',
        data: {
          // Plain JSON Map (no FormData)
          'userId': userId,
          'imageUrl': imageUrl,
          'caption': caption ?? '',
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;
        print('✅ Cubit success: $data');
        final photo = PhotoModel.fromJson(data['photo']);
        emit(PhotoUpLoaded(photo));
      } else if (response.statusCode! >= 400) {
        final errorMsg = response.data['message'] ?? 'Unknown error';
        throw Exception('Server error: ${response.statusCode} - $errorMsg');
      } else {
        throw Exception('Unexpected status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.type} - ${e.message}');
      if (e.response != null) {
        print('Server response: ${e.response?.data}');
        final errorMsg = e.response?.data['message'] ?? e.message;
        emit(PhotoError('Lỗi API: $errorMsg'));
      } else {
        emit(PhotoError('Lỗi kết nối: ${e.message}'));
      }
      throw e;
    } catch (e, stackTrace) {
      print('❌ Cubit error: $e');
      print('Stack: $stackTrace');
      emit(PhotoError("Không thể tải ảnh lên: $e"));
      throw e;
    }
  }

  // READ ALL (backend không hỗ trợ pagination hoặc filter userId, chỉ lấy tất cả)
  Future<void> fetchPhotos() async {
    // Đổi signature: bỏ userId, page, limit
    emit(PhotoLoading());
    try {
      // Không dùng query params vì backend không hỗ trợ
      final response = await _dio.get('/photos');

      if (response.statusCode == 200) {
        final data = response.data;
        print(data);
        final List<dynamic> photosJson = data['photos'] ?? [];
        final photos =
            photosJson.map((json) => PhotoModel.fromJson(json)).toList();
        emit(PhotoLoaded(photos));
      } else {
        throw Exception(
            'Fetch failed: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      print('❌ Fetch Dio error: ${e.message}');
      emit(PhotoError('Không thể lấy ảnh: ${e.message}'));
    } catch (e) {
      print('❌ Fetch error: $e');
      emit(PhotoError("Không thể lấy ảnh: $e"));
    }
  }

  // READ ONE
  Future<void> fetchPhotoById(String id) async {
    emit(PhotoLoading());
    try {
      final response = await _dio.get('/photos/$id');

      if (response.statusCode == 200) {
        final photo = PhotoModel.fromJson(response.data);
        emit(PhotoLoaded([photo]));
      } else if (response.statusCode == 404) {
        final errorMsg = response.data['message'] ?? "Không tìm thấy ảnh";
        emit(PhotoError(errorMsg));
      } else {
        emit(PhotoError("Không tìm thấy ảnh"));
      }
    } on DioException catch (e) {
      print('❌ Get Dio error: ${e.message}');
      if (e.response?.statusCode == 404) {
        final errorMsg = e.response?.data['message'] ?? 'Không tìm thấy ảnh';
        emit(PhotoError(errorMsg));
      } else {
        emit(PhotoError('Không thể lấy ảnh: ${e.message}'));
      }
    } catch (e) {
      print('❌ Get error: $e');
      emit(PhotoError("Không thể lấy ảnh: $e"));
    }
  }

  // UPDATE: Backend chưa có endpoint, tạm comment out
  /*
  Future<void> updatePhoto({
    required String id,
    String? imageUrl,
    String? caption,
  }) async {
    emit(PhotoUpdating());
    try {
      final response = await _dio.put(
        '/photos/$id',
        data: {
          'imageUrl': imageUrl ?? '',
          'caption': caption ?? '',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final updatedPhoto = PhotoModel.fromJson(data['photo']);
        emit(PhotoUpdated(updatedPhoto));
      } else {
        emit(PhotoError("Không thể cập nhật ảnh"));
      }
    } on DioException catch (e) {
      print('❌ Update Dio error: ${e.message}');
      emit(PhotoError('Không thể cập nhật ảnh: ${e.message}'));
    } catch (e) {
      print('❌ Update error: $e');
      emit(PhotoError("Không thể cập nhật ảnh: $e"));
    }
  }
  */

  // DELETE
  Future<void> deletePhoto(String photoId) async {
    emit(PhotoDeleting());
    try {
      final response = await _dio.delete('/photos/$photoId');

      if (response.statusCode == 200) {
        emit(PhotoDeleted(photoId));
        await fetchPhotos(); // Refetch to update the list
      } else if (response.statusCode == 404) {
        final errorMsg = response.data['message'] ?? "Không thể xóa ảnh";
        emit(PhotoError(errorMsg));
      } else {
        emit(PhotoError("Không thể xóa ảnh"));
      }
    } on DioException catch (e) {
      print('❌ Delete Dio error: ${e.message}');
      if (e.response?.statusCode == 404) {
        final errorMsg = e.response?.data['message'] ?? 'Không thể xóa ảnh';
        emit(PhotoError(errorMsg));
      } else {
        emit(PhotoError('Không thể xóa ảnh: ${e.message}'));
      }
    } catch (e) {
      print('❌ Delete error: $e');
      emit(PhotoError("Không thể xóa ảnh: $e"));
    }
  }
}
