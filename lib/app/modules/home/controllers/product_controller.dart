import 'package:get/get.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final bool isFavorite;
  final bool isOnSale;
  final double? salePrice;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isFavorite = false,
    this.isOnSale = false,
    this.salePrice,
  });
}

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var categories = <String>[].obs;
  var selectedCategory = ''.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProducts();
    _loadCategories();
    ever(searchQuery, (_) => _filterProducts());
    ever(selectedCategory, (_) => _filterProducts());
  }

  void _loadProducts() {
    products.assignAll([
      Product(
        id: 1,
        name: 'Produit Local A',
        description: 'Description du produit local A',
        price: 29.99,
        imageUrl: 'assets/images/product1.png',
        category: 'Alimentaire',
        rating: 4.5,
        reviewCount: 12,
        isOnSale: true,
        salePrice: 24.99,
      ),
      Product(
        id: 2,
        name: 'Produit Local B',
        description: 'Description du produit local B',
        price: 49.99,
        imageUrl: 'assets/images/product2.png',
        category: 'Artisanat',
        rating: 4.8,
        reviewCount: 8,
      ),
      Product(
        id: 3,
        name: 'Produit Local C',
        description: 'Description du produit local C',
        price: 19.99,
        imageUrl: 'assets/images/product3.png',
        category: 'Maison',
        rating: 4.2,
        reviewCount: 15,
        isOnSale: true,
        salePrice: 15.99,
      ),
      Product(
        id: 4,
        name: 'Produit Local D',
        description: 'Description du produit local D',
        price: 39.99,
        imageUrl: 'assets/images/product4.png',
        category: 'Vêtements',
        rating: 4.6,
        reviewCount: 20,
      ),
      Product(
        id: 5,
        name: 'Produit Local E',
        description: 'Description du produit local E',
        price: 59.99,
        imageUrl: 'assets/images/product5.png',
        category: 'Electronique',
        rating: 4.9,
        reviewCount: 25,
        isOnSale: true,
        salePrice: 49.99,
      ),
    ]);
    filteredProducts.assignAll(products);
  }

  void _loadCategories() {
    categories.assignAll(['Tous', 'Alimentaire', 'Artisanat', 'Maison', 'Vêtements', 'Electronique']);
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
  }

  void _filterProducts() {
    if (searchQuery.value.isEmpty && (selectedCategory.value.isEmpty || selectedCategory.value == 'Tous')) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products.where((product) {
          bool matchesSearch = product.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              product.description.toLowerCase().contains(searchQuery.value.toLowerCase());
          
          bool matchesCategory = selectedCategory.value.isEmpty || 
              selectedCategory.value == 'Tous' || 
              product.category == selectedCategory.value;
          
          return matchesSearch && matchesCategory;
        }).toList(),
      );
    }
  }

  void toggleFavorite(int productId) {
    var productIndex = products.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      products[productIndex] = Product(
        id: products[productIndex].id,
        name: products[productIndex].name,
        description: products[productIndex].description,
        price: products[productIndex].price,
        imageUrl: products[productIndex].imageUrl,
        category: products[productIndex].category,
        rating: products[productIndex].rating,
        reviewCount: products[productIndex].reviewCount,
        isFavorite: !products[productIndex].isFavorite,
        isOnSale: products[productIndex].isOnSale,
        salePrice: products[productIndex].salePrice,
      );
      
      // Also update in filtered products
      var filteredIndex = filteredProducts.indexWhere((p) => p.id == productId);
      if (filteredIndex != -1) {
        filteredProducts[filteredIndex] = products[productIndex];
      }
    }
  }
}