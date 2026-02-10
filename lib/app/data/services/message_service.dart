import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/message.dart';
import 'api_client.dart';
import 'exceptions/app_exception.dart';

class MessageService {
  final ApiClient _apiClient = Get.find();

  Future<List<Message>> getMessages(int conversationId) async {
    try {
      final response = await _apiClient.dio.get('/messages/conversation/$conversationId');
      return (response.data['data']['data'] ?? response.data['data'] as List)
          .map((json) => Message.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Message> sendMessage(int conversationId, String content) async {
    try {
      final response = await _apiClient.dio.post('/messages/send', data: {
        'conversation_id': conversationId,
        'content': content,
      });
      return Message.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }
}