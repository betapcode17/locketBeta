// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:locket_beta/model/photo_model.dart';

// class PhotoApiService {
//   static const String baseUrl = 'http://localhost:5000/api'; // Thay bằng production
//   late final Dio _dio;

//   PhotoApiService() {
//     _dio = Dio(BaseOptions(
//       baseUrl: baseUrl,
//       connectTimeout: const Duration(seconds: 5),
//       receiveTimeout: const Duration(seconds: 3),
//       headers: {'Content-Type': 'application/json'}, // Default cho JSON
//     ));

//     // Interceptor optional: Log requests/responses
//     _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
//   }

//   // CREATE: POST /photos (multipart cho file upload)
//   Future<PhotoModel?> uploadPhoto({
//     required String userId,
//     required String? filePath, // Path file từ image_picker (nếu upload binary)
//     required String imageUrl, // Fallback nếu chỉ gửi URL
//     String? caption,
//   }) async {
//     try {
//       FormData formData = FormData.fromMap({
//         'userId': userId,
//         'caption': caption ?? '',
//       });

//       // Nếu có file path, thêm multipart file (upload binary)
//       if (filePath != null && File(filePath).existsSync()) {
//         formData.files.add(MapEntry(
//           'image', // Field name backend expect (sửa controller nếu cần)
//           await MultipartFile.fromFile(filePath, filename: 'photo.jpg'),
//         ));
//       } else {
//         // Fallback: Gửi URL như string
//         formData.fields.add(MapEntry('imageUrl', imageUrl));
//       }

//       final response = await _dio.post(
//         '/photos',
//         data: formData,
//         options: Options(contentType: 'multipart/form-data'),
//       ).timeout(const Duration(seconds: 30)); // Timeout dài cho upload

//       if (response.statusCode == 201) {
//         final data = response.data;
//         return PhotoModel.fromJson(data['photo']);
//       } else {
//         throw DioException(
//           requestOptions: response.requestOptions,
//           response: response,
//           type: DioExceptionType.badResponse,
//           message: 'Upload failed: ${response.statusCode}',
//         );
//       }
//     } on DioException catch (e) {
//       throw Exception('Upload error: ${e.message}');
//     } catch (e) {
//       throw Exception('Network error: $e');
//     }
//   }

//   // READ ALL: GET /photos (với pagination)
//   Future<List<PhotoModel>> fetchPhotos({
//     int page = 1,
//     int limit = 10,
//     String? userId,
//   }) async {
//     try {
//       String query = '?page=$page&limit=$limit';
//       if (userId != null) query += '&userId=$userId';

//       final response = await _dio.get('/photos$query');

//       if (response.statusCode == 200) {
//         final List<dynamic> photosJson = response.data['photos'];
//         return photosJson.map((json) => PhotoModel.fromJson(json)).toList();
//       } else {
//         throw DioException(
//           requestOptions: response.requestOptions,
//           response: response,
//           type: DioExceptionType.badResponse,
//           message: 'Fetch failed: ${response.statusCode}',
//         );
//       }
//     } on DioException catch (e) {
//       throw Exception('Fetch error: ${e.message}');
//     } catch (e) {
//       throw Exception('Network error: $e');
//     }
//   }

//   // READ ONE: GET /photos/:id
//   Future<PhotoModel?> getPhotoById(String id) async {
//     try {
//       final response = await _dio.get('/photos/$id');

//       if (response.statusCode == 200) {
//         return PhotoModel.fromJson(response.data);
//       } else {
//         throw DioException(
//           requestOptions: response.requestOptions,
//           response: response,
//           type: DioExceptionType.badResponse,
//           message: 'Get photo failed: ${response.statusCode}',
//         );
//       }
//     } on DioException catch (e) {
//       throw Exception('Get error: ${e.message}');
//     } catch (e) {
//       throw Exception('Network error: $e');
//     }
//   }

//   // UPDATE: PUT /photos/:id (multipart nếu update file)
//   Future<PhotoModel?> updatePhoto({
//     required String id,
//     String? filePath,
//     String? imageUrl,
//     String? caption,
//   }) async {
//     try {
//       FormData formData = FormData.fromMap({
//         'caption': caption ?? '',
//       });

//       if (filePath != null && File(filePath).existsSync()) {
//         formData.files.add(MapEntry(
//           'image',
//           await MultipartFile.fromFile(filePath, filename: 'photo.jpg'),
//         ));
//       } else if (imageUrl != null) {
//         formData.fields.add(MapEntry('imageUrl', imageUrl));
//       }

//       final response = await _dio.put(
//         '/photos/$id',
//         data: formData,
//         options: Options(contentType: 'multipart/form-data'),
//       );

//       if (response.statusCode == 200) {
//         final data = response.data;
//         return PhotoModel.fromJson(data['photo']);
//       } else {
//         throw DioException(
//           requestOptions: response.requestOptions,
//           response: response,
//           type: DioExceptionType.badResponse,
//           message: 'Update failed: ${response.statusCode}',
//         );
//       }
//     } on DioException catch (e) {
//       throw Exception('Update error: ${e.message}');
//     } catch (e) {
//       throw Exception('Network error: $e');
//     }
//   }

//   // DELETE: DELETE /photos/:id
//   Future<bool> deletePhoto(String id) async {
//     try {
//       final response = await _dio.delete('/photos/$id');

//       if (response.statusCode == 200) {
//         return true;
//       } else {
//         throw DioException(
//           requestOptions: response.requestOptions,
//           response: response,
//           type: DioExceptionType.badResponse,
//           message: 'Delete failed: ${response.statusCode}',
//         );
//       }
//     } on DioException catch (e) {
//       throw Exception('Delete error: ${e.message}');
//     } catch (e) {
//       throw Exception('Network error: $e');
//     }
//   }
// }
