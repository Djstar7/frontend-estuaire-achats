import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/seller.dart';
import 'api_client.dart';
import 'exceptions/app_exception.dart';

class SellerService {
  final ApiClient _apiClient = Get.find();

  Future<List<Seller>> getTopSellers({int limit = 5}) async {
    try {
      final response = await _apiClient.dio.get('/sellers/top');
      final data = response.data;
      List<dynamic> items = [];
      if (data is Map) {
        if (data['sellers'] is List) {
          items = data['sellers'] as List;
        } else if (data['data'] is List) {
          items = data['data'] as List;
        }
      } else if (data is List) {
        items = data;
      }

      if (items.length > limit) {
        items = items.take(limit).toList();
      }

      return items
          .map((json) => Seller.fromJson(Map<String, dynamic>.from(json as Map)))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Seller> getSeller(int id) async {
    try {
      final response = await _apiClient.dio.get('/sellers/$id');
      final body = response.data;
      if (body is Map && body['seller'] != null) {
        return Seller.fromJson(Map<String, dynamic>.from(body['seller'] as Map));
      }
      if (body is Map && body['data'] != null) {
        return Seller.fromJson(Map<String, dynamic>.from(body['data'] as Map));
      }
      if (body is Map) {
        return Seller.fromJson(Map<String, dynamic>.from(body));
      }
      throw Exception('Invalid seller response');
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }
}
