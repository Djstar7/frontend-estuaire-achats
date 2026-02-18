import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../storage/local_storage_service.dart';

class ApiClient extends GetxService {
  static const String _localhostBaseUrl = 'http://127.0.0.1:8000/api/v1';
  static const String _androidDeviceBaseUrl = 'http://192.168.43.138:8000/api/v1';
  static bool get isDebug => kDebugMode;
  
  late Dio _dio;
  late LocalStorageService _localStorage;

  Dio get dio => _dio;
  String get baseUrl => _resolveBaseUrl();

  @override
  Future<void> onInit() async {
    super.onInit();

    // Récupération du service de stockage local centralisé
    _localStorage = Get.find<LocalStorageService>();

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
    // Récupère le token d'authentification depuis le service de stockage
    return _localStorage.getAuthToken();
  }
  
  Future<void> setBaseUrl(String? s) async {}
}
