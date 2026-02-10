import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/notification.dart';
import 'api_client.dart';
import 'exceptions/app_exception.dart';

class NotificationService {
  final ApiClient _apiClient = Get.find();

  Future<List<Notification>> getNotifications({bool? unread}) async {
    try {
      final params = <String, dynamic>{};
      if (unread != null) params['unread'] = unread;

      final response = await _apiClient.dio.get('/notifications', queryParameters: params);
      return (response.data['data']['data'] ?? response.data['data'] as List)
          .map((json) => Notification.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Notification> markAsRead(int id) async {
    try {
      final response = await _apiClient.dio.put('/notifications/$id/read');
      return Notification.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAllRead() async {
    try {
      await _apiClient.dio.put('/notifications/mark-all-read');
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }
}