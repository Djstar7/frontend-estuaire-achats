import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/order.dart';
import 'api_client.dart';
import 'exceptions/app_exception.dart';

class OrderService {
  final ApiClient _apiClient = Get.find();

  Future<List<Order>> getMyOrders() async {
    try {
      final response = await _apiClient.dio.get('/orders');
      final data = response.data;
      List<dynamic> items = [];
      if (data is Map) {
        if (data['orders'] is Map && data['orders']['data'] is List) {
          items = data['orders']['data'] as List;
        } else if (data['orders'] is List) {
          items = data['orders'] as List;
        } else if (data['data'] is List) {
          items = data['data'] as List;
        }
      } else if (data is List) {
        items = data;
      }

      return items
          .map((json) => Order.fromJson(Map<String, dynamic>.from(json as Map)))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Order> getOrder(int id) async {
    try {
      final response = await _apiClient.dio.get('/orders/$id');
      final body = response.data;
      if (body is Map && body['order'] != null) {
        return Order.fromJson(Map<String, dynamic>.from(body['order'] as Map));
      }
      if (body is Map && body['data'] != null) {
        return Order.fromJson(Map<String, dynamic>.from(body['data'] as Map));
      }
      if (body is Map) {
        return Order.fromJson(Map<String, dynamic>.from(body));
      }
      throw Exception('Invalid order response');
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Order>> createOrders(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/orders', data: data);
      final body = response.data;
      List<dynamic> items = [];
      if (body is Map && body['orders'] is List) {
        items = body['orders'] as List;
      } else if (body is Map && body['data'] is List) {
        items = body['data'] as List;
      }
      return items
          .map((json) => Order.fromJson(Map<String, dynamic>.from(json as Map)))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Order> createOrder(Map<String, dynamic> data) async {
    try {
      final orders = await createOrders(data);
      if (orders.isNotEmpty) return orders.first;
      throw Exception('No orders created');
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Order> updateOrderStatus(int id, String status) async {
    try {
      final response = await _apiClient.dio.patch(
        '/orders/$id/status',
        data: {'status': status},
      );
      final body = response.data;
      if (body is Map && body['order'] != null) {
        return Order.fromJson(Map<String, dynamic>.from(body['order'] as Map));
      }
      if (body is Map && body['data'] != null) {
        return Order.fromJson(Map<String, dynamic>.from(body['data'] as Map));
      }
      if (body is Map) {
        return Order.fromJson(Map<String, dynamic>.from(body));
      }
      throw Exception('Invalid order response');
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }

  // delete order, cancel order, etc. can be added here
  Future<void> deleteOrder(int id) async {
    try {
      await _apiClient.dio.delete('/orders/$id');
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }
}
