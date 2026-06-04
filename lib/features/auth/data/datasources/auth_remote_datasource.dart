import 'package:dio/dio.dart';

import '../../../../core/errors/exception_mapper.dart';
import '../../../../network/api_client.dart';
import '../../../../network/api_endpoints.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String name,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) {
    return _postAuth(
      ApiEndpoints.login,
      {'email': email, 'password': password},
    );
  }

  @override
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String name,
  }) {
    return _postAuth(
      ApiEndpoints.register,
      {'email': email, 'password': password, 'name': name},
    );
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.dio.post<void>(ApiEndpoints.logout);
    } on DioException catch (error) {
      throw ExceptionMapper.fromDio(error);
    }
  }

  Future<AuthResponseModel> _postAuth(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        path,
        data: body,
      );
      return AuthResponseModel.fromJson(response.data ?? {});
    } on DioException catch (error) {
      throw ExceptionMapper.fromDio(error);
    }
  }
}
