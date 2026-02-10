import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import 'api_client.dart';
import 'exceptions/app_exception.dart';

class ProductService {
  final ApiClient _apiClient = Get.find();

  Future<List<Product>> getProducts({
    int? page,
    String? search,
    int? categoryId,
    int? sellerId,
  }) async {
    try {
      final params = <String, dynamic>{};
      if (page != null) params['page'] = page;
      if (search != null) params['search'] = search;
      if (categoryId != null) params['category_id'] = categoryId;
      if (sellerId != null) params['seller_id'] = sellerId;

      final response = await _apiClient.dio.get(
        '/products',
        queryParameters: params,
      );

      final data = response.data;
      List<dynamic> items = [];
      if (data is Map) {
        final products = data['products'];
        final dataField = data['data'];

        if (products is List) {
          items = products;
        } else if (products is Map) {
          if (products['data'] is List) {
            items = products['data'] as List;
          } else if (products['items'] is List) {
            items = products['items'] as List;
          }
        } else if (dataField is List) {
          items = dataField;
        } else if (dataField is Map) {
          if (dataField['data'] is List) {
            items = dataField['data'] as List;
          } else if (dataField['products'] is List) {
            items = dataField['products'] as List;
          } else if (dataField['products'] is Map &&
              dataField['products']['data'] is List) {
            items = dataField['products']['data'] as List;
          }
        }
      } else if (data is List) {
        items = data;
      }

      print('Items: $items');

      return items
          .map((json) => Product.fromJson(Map<String, dynamic>.from(json as Map)))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> getProduct(int id) async {
    try {
      final response = await _apiClient.dio.get('/products/$id');
      final data = response.data;
      if (data is Map && data['data'] != null) {
        return Product.fromJson(Map<String, dynamic>.from(data['data'] as Map));
      }
      if (data is Map && data['product'] != null) {
        return Product.fromJson(Map<String, dynamic>.from(data['product'] as Map));
      }
      if (data is Map) {
        return Product.fromJson(Map<String, dynamic>.from(data));
      }
      throw Exception('Invalid product response');
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Product>> getMyProducts() async {
    try {
      final response = await _apiClient.dio.get('/products/my-products');
      final data = response.data;
      final List<dynamic> items;
      if (data is Map && data['data'] is Map && data['data']['data'] is List) {
        items = data['data']['data'] as List;
      } else if (data is Map && data['data'] is List) {
        items = data['data'] as List;
      } else if (data is List) {
        items = data;
      } else {
        items = [];
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

  Future<Product> createProduct(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/products', data: data);
      final body = response.data;
      if (body is Map && body['data'] != null) {
        return Product.fromJson(Map<String, dynamic>.from(body['data'] as Map));
      }
      if (body is Map && body['product'] != null) {
        return Product.fromJson(Map<String, dynamic>.from(body['product'] as Map));
      }
      if (body is Map) {
        return Product.fromJson(Map<String, dynamic>.from(body));
      }
      throw Exception('Invalid product response');
    } on DioException catch (e) {
      throw AppException.fromDio(e);
    } catch (e) {
      rethrow;
    }
  }
}
