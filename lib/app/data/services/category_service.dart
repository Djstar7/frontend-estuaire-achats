import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/category.dart';
import 'api_client.dart';
import 'exceptions/app_exception.dart';

class CategoryService {
  final ApiClient _apiClient = Get.find();

  Future<List<Category>> getAllCategories() async {
    try {
      final response = await _apiClient.dio.get('/categories');
      final data = response.data;
      List<dynamic> items = [];
      if (data is List) {
        items = data;
      } else if (data is Map) {
        if (data['categories'] is List) {
          items = data['categories'] as List;
        } else if (data['data'] is List) {
          items = data['data'] as List;
        } else if (data['data'] is Map && data['data']['data'] is List) {
          items = data['data']['data'] as List;
        }
      }
      return items
          .map((json) => Category.fromJson(Map<String, dynamic>.from(json as Map)))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Category> getCategory(int id) async {
    try {
      final response = await _apiClient.dio.get('/categories/$id');
      final data = response.data;
      if (data is Map && data['data'] != null) {
        return Category.fromJson(Map<String, dynamic>.from(data['data'] as Map));
      }
      if (data is Map) {
        return Category.fromJson(Map<String, dynamic>.from(data));
      }
      throw Exception('Invalid category response');
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }
}
