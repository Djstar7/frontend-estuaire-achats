import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product.dart';
import '../../../data/services/api_client.dart';
import '../../../modules/cart/controllers/cart_controller.dart';
import '../../../modules/products/controllers/products_controller.dart';
import '../../../utils/formatters.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key});

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
              CarouselSlider(
                options: CarouselOptions(
                  height: 260,
                  viewportFraction: 1,
                ),
                items: images
                    .map(
                      (image) => _ProductImage(imageUrl: image),
                    )
                    .toList(),
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
                      onPressed: () {
                        cartController.addToCart(product);
                        Get.snackbar(
                          'Panier',
                          'Produit ajouté au panier.',
                          snackPosition: SnackPosition.BOTTOM,
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
