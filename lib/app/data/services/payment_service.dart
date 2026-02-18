import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/payment.dart';
import 'api_client.dart';
import 'exceptions/app_exception.dart';

class PaymentService {
  final ApiClient _apiClient = Get.find();

  Future<Payment> initiatePayment({
    required int orderId,
    required String gateway,
    required double amount,
    required String currency,
    required String deliveryAddress,
    int? deliveryZoneId,
    String? phone,
  }) async {
    try {
      final response = await _apiClient.dio.post('/payments/initialize', data: {
        'order_id': orderId,
        'gateway': gateway,
        'amount': amount,
        'currency': currency,
        'delivery_address': deliveryAddress,
        if (deliveryZoneId != null) 'delivery_zone_id': deliveryZoneId,
        if (phone != null && phone.trim().isNotEmpty)
          'metadata': {'phone': phone.trim()},
      });
      final body = response.data;
      if (body is Map && body['payment'] != null) {
        return Payment.fromJson(Map<String, dynamic>.from(body['payment'] as Map));
      }
      if (body is Map && body['data'] != null) {
        return Payment.fromJson(Map<String, dynamic>.from(body['data'] as Map));
      }
      if (body is Map) {
        return Payment.fromJson(Map<String, dynamic>.from(body));
      }
      throw Exception('Invalid payment response');
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
