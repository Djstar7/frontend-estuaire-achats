import 'package:get/get.dart';
import '../../../data/models/category.dart';
import '../../../data/models/product.dart';
import '../../../data/services/category_service.dart';
import '../../../data/services/product_service.dart';
import '../../../data/services/like_service.dart';
import '../../auth/controllers/auth_controller.dart';

class ProductsController extends GetxController {
  final ProductService _productService = Get.find();
  final CategoryService _categoryService = Get.find();
  final LikeService _likeService = Get.find();
  final AuthController _authController = Get.find();

  final products = <Product>[].obs;
  final filteredProducts = <Product>[].obs;
  final favoriteProductsList = <Product>[].obs;
  final categories = <Category>[].obs;
  final favoriteIds = <int>{}.obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final searchQuery = ''.obs;
  final selectedCategoryId = RxnInt();

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
    loadFavorites();
    ever(searchQuery, (_) => _applyFilters());
    ever(selectedCategoryId, (_) => _applyFilters());
  }

  Future<void> loadInitialData() async {
    await Future.wait([
      loadCategories(),
      loadProducts(),
    ]);
  }

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final data = await _productService.getProducts();
      products.assignAll(data);
      _applyFilters();
    } catch (e) {
      errorMessage.value = 'Impossible de charger les produits.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCategories() async {
    try {
      final data = await _categoryService.getAllCategories();
      categories.assignAll(data);
    } catch (e) {
      // Silent for UI fallback
    }
  }

  Future<void> loadFavorites() async {
    if (!_authController.isLoggedIn) {
      favoriteIds.clear();
      favoriteProductsList.clear();
      return;
    }
    try {
      final favorites = await _likeService.getFavorites();
      favoriteProductsList.assignAll(favorites);
      favoriteIds.assignAll(
        favorites.map((p) => p.id).whereType<int>().toSet(),
      );
    } catch (e) {
      // Silent for UI fallback
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query.trim();
  }

  void setSelectedCategory(int? categoryId) {
    selectedCategoryId.value = categoryId;
  }

  void toggleFavorite(Product product) {
    final id = product.id;
    if (id == null) return;
    if (!_authController.isLoggedIn) {
      Get.snackbar(
        'Favoris',
        'Connectez-vous pour ajouter des favoris.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final isFav = favoriteIds.contains(id);
    if (isFav) {
      favoriteIds.remove(id);
      favoriteProductsList.removeWhere((p) => p.id == id);
      _likeService.removeFavorite(id).catchError((_) {
        favoriteIds.add(id);
        favoriteProductsList.add(product);
      });
    } else {
      favoriteIds.add(id);
      favoriteProductsList.add(product);
      _likeService.addFavorite(id).catchError((_) {
        favoriteIds.remove(id);
        favoriteProductsList.removeWhere((p) => p.id == id);
      });
    }
  }

  bool isFavorite(Product product) {
    final id = product.id;
    if (id == null) return false;
    return favoriteIds.contains(id);
  }

  String categoryLabel(int? categoryId) {
    if (categoryId == null) return 'Sans catégorie';
    final match = categories.firstWhereOrNull((c) => c.id == categoryId);
    return match?.name ?? 'Catégorie #$categoryId';
  }

  void _applyFilters() {
    final query = searchQuery.value.toLowerCase();
    final categoryId = selectedCategoryId.value;
    filteredProducts.assignAll(
      products.where((product) {
        final name = product.name?.toLowerCase() ?? '';
        final description = product.description?.toLowerCase() ?? '';
        final matchesQuery = query.isEmpty ||
            name.contains(query) ||
            description.contains(query);
        final matchesCategory =
            categoryId == null || product.categoryId == categoryId;
        final inStock = (product.quantity ?? 0) > 0;
        return matchesQuery && matchesCategory && inStock;
      }).toList(),
    );
  }
}
