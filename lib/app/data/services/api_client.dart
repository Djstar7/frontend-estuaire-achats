import 'dart:io' show Platform, SocketException;
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'exceptions/app_exception.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class ApiClient extends GetxService {
  static const String _localhostBaseUrl = 'http://127.0.0.1:8000/api/v1';
  static const String _androidDeviceBaseUrl = 'http://192.168.43.138:8000/api/v1';
  static bool get isDebug => kDebugMode;
  
  late Dio _dio;
  late GetStorage _storage;

  Dio get dio => _dio;
  String get baseUrl => _resolveBaseUrl();

  @override
  Future<void> onInit() async {
    super.onInit();
    
    // Initialize GetStorage
    _storage = GetStorage();
    
    final options = BaseOptions(
      baseUrl: _resolveBaseUrl(),
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    _dio = Dio(options);

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add authorization header if token exists
          String? token = await _getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) => handler.next(response),
        onError: (DioException error, handler) async {
          // Log the error but don't reject with AppException
          // Instead, we'll handle it in the service layer
          return handler.next(error);
        },
      ),
    );

    // Add pretty logger in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          compact: true,
        ),
      );
    }
  }

  String _resolveBaseUrl() {
    if (Platform.isAndroid) {
      return _androidDeviceBaseUrl;
    }
    return _localhostBaseUrl;
  }

  Future<String?> _getToken() async {
    // Retrieve token from GetStorage
    return _storage.read('auth_token');
  }
  
  AppException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException('Request timeout');
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case 400:
            return AppException('Bad Request');
          case 401:
            return UnauthorizedException('Unauthorized');
          case 403:
            return AppException('Forbidden');
          case 404:
            return NotFoundException('Resource not found');
          case 422:
            // Handle validation errors
            final errors = error.response?.data['errors'] as Map<String, dynamic>?;
            return ValidationException('Validation failed', errors?.cast<String, List<String>>());
          case 500:
            return ServerException('Internal Server Error');
          default:
            return ServerException('Server Error ${error.response?.statusCode}');
        }
      case DioExceptionType.cancel:
        return AppException('Request cancelled');
      case DioExceptionType.connectionError:
        return NetworkException('Connection Error');
      case DioExceptionType.badCertificate:
        return NetworkException('Certificate Error');
      case DioExceptionType.unknown:
      default:
        if (error.error is SocketException) {
          return NoInternetException('No Internet Connection');
        }
        return NetworkException('Network Error');
    }
  }

  Future<void> setBaseUrl(String? s) async {}
}
