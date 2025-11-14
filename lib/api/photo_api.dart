import 'package:dio/dio.dart';
import 'package:locket_beta/model/photo_model.dart';

class PhotoApi {
  static const String baseUrl =
      'http://10.0.2.2:5001/api'; // FIX: localhost → 10.0.2.2 (emulator); thay IP máy cho device
  late final Dio _dio;

  PhotoApi() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15), // Tăng để tránh timeout
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json'
      }, // FIX: JSON only, no multipart
    ));

    // Interceptor log full request/response/error
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('📤 Dio Request: ${options.method} ${options.path}');
        print('Headers: ${options.headers}');
        print('Body: ${options.data}'); // Sẽ print JSON map
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
        if (error.stackTrace != null) {
          print('Stack trace: ${error.stackTrace}');
        }
        handler.next(error); // Pass error to caller (cubit catch)
      },
    ));
  }

  // CREATE: POST JSON (FIX: plain Map, no FormData)
  Future<PhotoModel?> uploadPhoto({
    required String userId,
    required String imageUrl,
    String? caption,
  }) async {
    try {
      print(
          '🔄 Service upload: userId=$userId, imageUrl=$imageUrl, caption=$caption');
      final response = await _dio.post(
        '/photos',
        data: {
          // FIX: Plain JSON Map, no FormData/multipart
          'userId': userId,
          'imageUrl': imageUrl,
          'caption': caption ?? '',
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;
        print('✅ Service success: $data');
        return PhotoModel.fromJson(data['photo']);
      } else {
        throw Exception(
            'Server error: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.type} - ${e.message}');
      if (e.response != null) {
        print('Full server response: ${e.response?.data}');
      }
      throw e; // Throw để cubit handle
    } catch (e, stackTrace) {
      print('❌ Service general error: $e');
      print('Stack: $stackTrace');
      throw e;
    }
  }

  // READ ALL (GET JSON, giữ nguyên)
  Future<List<PhotoModel>> fetchPhotos({
    int page = 1,
    int limit = 10,
    String? userId,
  }) async {
    try {
      String query = '?page=$page&limit=$limit';
      if (userId != null) query += '&userId=$userId';

      final response = await _dio.get('/photos$query');

      if (response.statusCode == 200) {
        final List<dynamic> photosJson = response.data['photos'];
        return photosJson.map((json) => PhotoModel.fromJson(json)).toList();
      } else {
        throw Exception(
            'Fetch failed: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Fetch Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // READ ONE: GET /photos/:id (dùng _id)
  Future<PhotoModel?> getPhotoById(String id) async {
    try {
      final response = await _dio.get('/photos/$id');

      if (response.statusCode == 200) {
        return PhotoModel.fromJson(response.data);
      } else {
        throw Exception(
            'Get photo failed: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Get Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // UPDATE (backend chưa có, optional)
  Future<PhotoModel?> updatePhoto({
    required String id,
    String? imageUrl,
    String? caption,
  }) async {
    try {
      final response = await _dio.put(
        '/photos/$id',
        data: {
          'imageUrl': imageUrl,
          'caption': caption ?? '',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return PhotoModel.fromJson(data['photo']);
      } else {
        throw Exception(
            'Update failed: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Update Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // DELETE
  Future<bool> deletePhoto(String id) async {
    try {
      final response = await _dio.delete('/photos/$id');

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
            'Delete failed: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Delete Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
