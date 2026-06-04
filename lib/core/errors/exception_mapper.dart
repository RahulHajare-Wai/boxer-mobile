import 'package:dio/dio.dart';

import 'app_exception.dart';

class ExceptionMapper {
  ExceptionMapper._();

  static AppException fromDio(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = _messageFromResponse(error) ?? error.message ?? 'Network error';

    switch (statusCode) {
      case 401:
        return UnauthorizedException(message: message, code: '401', data: error.response?.data);
      case 403:
        return ForbiddenException(message: message, code: '403', data: error.response?.data);
      case 404:
        return NotFoundException(message: message, code: '404', data: error.response?.data);
      case 400:
      case 422:
        return ValidationException(message: message, code: statusCode.toString(), data: error.response?.data);
      default:
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout) {
          return TimeoutException(message: message, code: error.type.name, data: error.response?.data);
        }
        if (error.type == DioExceptionType.connectionError) {
          return NetworkException(message: message, code: error.type.name, data: error.response?.data);
        }
        if (statusCode != null && statusCode >= 500) {
          return ServerException(message: message, code: statusCode.toString(), data: error.response?.data);
        }
        return NetworkException(message: message, code: statusCode?.toString(), data: error.response?.data);
    }
  }

  static String? _messageFromResponse(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['error'];
      if (message != null) return message.toString();
    }
    return null;
  }
}
