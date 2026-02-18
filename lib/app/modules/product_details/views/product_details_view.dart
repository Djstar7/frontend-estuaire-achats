import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product.dart';
import '../../../data/services/api_client.dart';
import '../../../modules/cart/controllers/cart_controller.dart';
import '../../../modules/products/controllers/products_controller.dart';
import '../../../utils/formatters.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int _currentImageIndex = 0;
  final carousel.CarouselSliderController _carouselController = carousel.CarouselSliderController();

  void _goToPreviousImage() {
    _carouselController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _goToNextImage() {
    _carouselController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _updateCurrentIndex(int index) {
    setState(() {
      _currentImageIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = Get.arguments as Product?;
    final cartController = Get.find<CartController>();
    final productsController = Get.find<ProductsController>();

    if (product == null) {
      return const Scaffold(
        body: Center(child: Text('Produit introuvable.')),
      );
    }

    final images = product.images ?? [];
    final stock = product.quantity ?? 0;
    final isOutOfStock = stock <= 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du produit'),
        actions: [
          Obx(() {
            final isFavorite = productsController.isFavorite(product);
            return IconButton(
              onPressed: () => productsController.toggleFavorite(product),
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (images.isNotEmpty)
              Stack(
                children: [
                  carousel.CarouselSlider.builder(
                    carouselController: _carouselController,
                    itemCount: images.length,
                    itemBuilder: (BuildContext context, int index, int realIndex) {
                      return _ProductImage(imageUrl: images[index]);
                    },
                    options: carousel.CarouselOptions(
                      height: 260,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        _updateCurrentIndex(index);
                      },
                    ),
                  ),
                  if (images.length > 1)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_currentImageIndex + 1}/${images.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  // Left arrow
                  if (images.length > 1)
                    Positioned(
                      top: 120,
                      left: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            _goToPreviousImage();
                          },
                          icon: const Icon(
                            Icons.arrow_left,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  // Right arrow
                  if (images.length > 1)
                    Positioned(
                      top: 120,
                      right: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            _goToNextImage();
                          },
                          icon: const Icon(
                            Icons.arrow_right,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              )
            else
              const SizedBox(
                height: 240,
                child: _ProductImage(),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? 'Produit',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatCurrency(product.price),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Display brand information if available
                  if (product.brand != null && product.brand!.name != null)
                    Text(
                      'Marque: ${product.brand!.name}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  const SizedBox(height: 8),
                  // Display stock quantity if available
                  if (product.quantity != null)
                    Text(
                      'Stock: ${product.quantity} unités',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  if (isOutOfStock)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Rupture de stock',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    productsController.categoryLabel(product.categoryId),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description ?? 'Aucune description disponible.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isOutOfStock
                          ? null
                          : () {
                              _addToCartWithoutDeliveryInfo(
                                product,
                                cartController,
                              );
                            },
                      icon: const Icon(Icons.shopping_cart_outlined),
                      label: const Text('Ajouter au panier'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addToCartWithoutDeliveryInfo(
    Product product,
    CartController cartController,
  ) async {
    try {
      // First, add to cart via API (database)
      await cartController.createDirectOrder(
        productId: product.id!,
        quantity: 1, // Default quantity
      );

      Get.snackbar(
        'Succès',
        'Produit ajouté au panier avec succès!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible d\'ajouter le produit au panier: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

class _ProductImage extends StatelessWidget {
  final String? imageUrl;

  const _ProductImage({this.imageUrl});

  String? _resolveNetworkUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('http')) return url;
    if (url.startsWith('assets/')) return null;

    final apiClient = Get.find<ApiClient>();
    var base = apiClient.baseUrl;
    final apiIndex = base.indexOf('/api/');
    if (apiIndex != -1) {
      base = base.substring(0, apiIndex);
    }
    if (base.endsWith('/')) {
      base = base.substring(0, base.length - 1);
    }
    final path = url.startsWith('/') ? url : '/$url';
    return '$base$path';
  }

  @override
  Widget build(BuildContext context) {
    final networkUrl = _resolveNetworkUrl(imageUrl);
    if (networkUrl != null) {
      return Image.network(
        networkUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => _placeholder(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return _placeholder(isLoading: true);
        },
      );
    }

    if (imageUrl != null && imageUrl!.startsWith('assets/')) {
      return Image.asset(
        imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }

    return _placeholder();
  }

  Widget _placeholder({bool isLoading = false}) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : const Icon(Icons.image, size: 64, color: Colors.grey),
      ),
    );
  }
}
