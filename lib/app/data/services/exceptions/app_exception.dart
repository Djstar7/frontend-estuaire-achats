import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, [this.statusCode]);

  factory AppException.fromDio(DioException error) {
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
        return NetworkException('Network Error');
    }
  }

  @override
  String toString() => 'AppException: $message';
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String message = 'Unauthorized']) : super(message, 401);
}

class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  ValidationException(String message, [this.errors]) : super(message, 422);
}

class ServerException extends AppException {
  ServerException([String message = 'Server Error']) : super(message, 500);
}

class NetworkException extends AppException {
  NetworkException([String message = 'Network Error']) : super(message);
}

class NoInternetException extends AppException {
  NoInternetException([String message = 'No Internet Connection']) : super(message);
}

class TimeoutException extends AppException {
  TimeoutException([String message = 'Request Timeout']) : super(message);
}

class NotFoundException extends AppException {
  NotFoundException([String message = 'Not Found']) : super(message, 404);
}