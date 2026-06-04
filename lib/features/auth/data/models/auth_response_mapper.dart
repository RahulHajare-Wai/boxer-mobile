import '../../domain/entities/auth_response.dart';
import 'auth_response_model.dart';

extension AuthResponseModelMapper on AuthResponseModel {
  AuthResponse toEntity() => AuthResponse(user: user, token: token);
}
