import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: "http://10.0.2.2:5000",
      headers: {"Content-Type": "application/json"},
      sendTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // auto add access token into header
        final prefs = await SharedPreferences.getInstance();
        final accessToken = prefs.getString("accessToken");
        if (accessToken != null) {
          options.headers["Authorization"] = "Bearer $accessToken";
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        // refresh here if 401
        if (e.response?.statusCode == 401) {
          final prefs = await SharedPreferences.getInstance();
          final refreshToken = prefs.getString("refreshToken");

          if (refreshToken != null) {
            try {
              //call API refresh token
              final response = await dio.post(
                "/api/auth/refresh",
                data: {"refreshToken": refreshToken},
              );

              final newAccessToken = response.data["accessToken"];
              await prefs.setString("accessToken", newAccessToken);

              // retry ori res
              final opts = e.requestOptions;
              opts.headers["Authorization"] = "Bearer $newAccessToken";
              final clonedResponse = await dio.fetch(opts);
              return handler.resolve(clonedResponse);
            } catch (e) {
              // refresh token fail → logout
              return handler.reject(e as DioException);
            }
          }
        }
        return handler.next(e);
      },
    ));
  }
}
