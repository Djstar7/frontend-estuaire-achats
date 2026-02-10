import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/cart/controllers/cart_controller.dart';
import '../modules/products/controllers/products_controller.dart';
import '../routes/app_pages.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final int crossAxisCount;

  const ProductGrid({super.key, this.crossAxisCount = 2});

  @override
  Widget build(BuildContext context) {
    final productsController = Get.find<ProductsController>();
    final cartController = Get.find<CartController>();

    return Obx(() {
      if (productsController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (productsController.errorMessage.value.isNotEmpty) {
        return Center(child: Text(productsController.errorMessage.value));
      }

      final productList = productsController.filteredProducts;
      if (productList.isEmpty) {
        return const Center(child: Text('Aucun produit disponible.'));
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.68,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: productList.length,
        itemBuilder: (context, index) {
          final product = productList[index];
          return ProductCard(
            product: product,
            onTap: () => Get.toNamed(
              Routes.PRODUCT_DETAILS,
              arguments: product,
            ),
            onAddToCart: () {
              cartController.addToCart(product);
              Get.snackbar(
                'Panier',
                'Produit ajouté au panier.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          );
        },
      );
    });
  }
}
