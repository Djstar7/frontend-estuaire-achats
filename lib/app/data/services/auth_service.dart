import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../models/user.dart';
import '../storage/local_storage_service.dart';
import 'api_client.dart';
import 'exceptions/app_exception.dart';

class AuthService {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final LocalStorageService _storage = Get.find<LocalStorageService>();

  Future<User> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      
      final body = response.data;

      // Store the token
      final token = body['token'] ??
          (body['data'] is Map ? body['data']['token'] : null);
      if (token != null) {
        await _storage.saveAuthToken(token);
      }
      
      if (body['user'] != null) {
        return User.fromJson(Map<String, dynamic>.from(body['user']));
      }
      if (body['data'] != null) {
        return User.fromJson(Map<String, dynamic>.from(body['data']));
      }
      throw Exception('Invalid login response');
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> register(String name, String email, String password, String phone) async {
    try {
      final response = await _apiClient.dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      });
      
      final body = response.data;

      // Store the token
      final token = body['token'] ??
          (body['data'] is Map ? body['data']['token'] : null);
      if (token != null) {
        await _storage.saveAuthToken(token);
      }
      
      if (body['user'] != null) {
        return User.fromJson(Map<String, dynamic>.from(body['user']));
      }
      if (body['data'] != null) {
        return User.fromJson(Map<String, dynamic>.from(body['data']));
      }
      throw Exception('Invalid register response');
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> getProfile() async {
    try {
      final response = await _apiClient.dio.get('/auth/profile');
      return User.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.dio.post('/auth/logout');
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    } finally {
      // Clear the stored token et l'état d'authentification local
      await _storage.clearAuthData();
    }
  }
}
