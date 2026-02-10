import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/conversation.dart';
import 'api_client.dart';
import 'exceptions/app_exception.dart';

class ConversationService {
  final ApiClient _apiClient = Get.find();

  Future<List<Conversation>> getMyConversations() async {
    try {
      final response = await _apiClient.dio.get('/conversations/my-conversations');
      return (response.data['data']['data'] ?? response.data['data'] as List)
          .map((json) => Conversation.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Conversation> getConversation(int id) async {
    try {
      final response = await _apiClient.dio.get('/conversations/$id');
      return Conversation.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Conversation> startConversation(int recipientId) async {
    try {
      final response = await _apiClient.dio.post('/conversations/start', data: {
        'recipient_id': recipientId,
      });
      return Conversation.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }
}