import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/services/api_client.dart';
import '../data/models/product.dart';
import '../modules/products/controllers/products_controller.dart';
import '../utils/formatters.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final productsController = Get.find<ProductsController>();
    final imageUrl = product.images?.isNotEmpty == true ? product.images!.first : null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 180,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _ProductImage(imageUrl: imageUrl),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Obx(() {
                      final isFavorite = productsController.isFavorite(product);
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          iconSize: 18,
                          onPressed: () => productsController.toggleFavorite(product),
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey[700],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? 'Produit',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatCurrency(product.price),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: onAddToCart,
                      child: const Text('Ajouter'),
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
        errorBuilder: (context, error, stackTrace) => _placeholder(),
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
        errorBuilder: (context, error, stackTrace) => _placeholder(),
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
            : const Icon(Icons.image, size: 48, color: Colors.grey),
      ),
    );
  }
}
