import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/payment.dart';
import 'api_client.dart';
import 'exceptions/app_exception.dart';

class PaymentService {
  final ApiClient _apiClient = Get.find();

  Future<Payment> initiatePayment(int orderId, String method) async {
    try {
      final response = await _apiClient.dio.post('/payments/initiate', data: {
        'order_id': orderId,
        'method': method,
      });
      return Payment.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Payment> getPaymentStatus(String reference) async {
    try {
      final response = await _apiClient.dio.get('/payments/status/$reference');
      return Payment.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }
}