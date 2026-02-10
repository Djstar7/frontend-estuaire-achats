import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../products/controllers/products_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/formatters.dart';
import '../../../data/services/api_client.dart';

class HorizontalProductList extends StatelessWidget {
  final int limit;

  const HorizontalProductList({Key? key, this.limit = 10}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsController = Get.find<ProductsController>();

    return SizedBox(
      height: 200,
      child: Obx(() {
        final products = productsController.filteredProducts.take(limit).toList();
        if (products.isEmpty) {
          return const Center(child: Text('Aucun produit disponible.'));
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final imageUrl = product.images?.isNotEmpty == true ? product.images!.first : null;
            return GestureDetector(
              onTap: () => Get.toNamed(Routes.PRODUCT_DETAILS, arguments: product),
              child: Container(
                width: 150,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: SizedBox(
                        height: 110,
                        width: double.infinity,
                        child: _ProductImage(imageUrl: imageUrl),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        product.name ?? 'Produit',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        formatCurrency(product.price),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
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
            : const Icon(Icons.image, size: 40, color: Colors.grey),
      ),
    );
  }
}
