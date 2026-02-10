import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import 'api_client.dart';
import 'exceptions/app_exception.dart';

class LikeService {
  final ApiClient _apiClient = Get.find();

  Future<List<Product>> getFavorites() async {
    try {
      final response = await _apiClient.dio.get('/likes');
      final data = response.data;
      List<dynamic> items = [];
      if (data is Map) {
        if (data['products'] is List) {
          items = data['products'] as List;
        } else if (data['likes'] is List) {
          items = (data['likes'] as List)
              .map((like) => (like is Map ? like['product'] : null))
              .where((p) => p != null)
              .toList();
        }
      } else if (data is List) {
        items = data;
      }

      return items
          .map((json) => Product.fromJson(Map<String, dynamic>.from(json as Map)))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addFavorite(int productId) async {
    try {
      await _apiClient.dio.post('/likes', data: {'product_id': productId});
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFavorite(int productId) async {
    try {
      await _apiClient.dio.delete('/likes/$productId');
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }
}
