import 'package:dio/dio.dart';

import '../core/constants/app_constants.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/log_interceptor.dart';

class ApiClient {
  ApiClient({required String baseUrl})
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: Duration(milliseconds: AppConstants.connectTimeout),
            receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
            sendTimeout: Duration(milliseconds: AppConstants.sendTimeout),
          ),
        ) {
    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(AppLogInterceptor());
  }

  final Dio dio;
}