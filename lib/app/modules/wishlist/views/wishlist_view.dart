import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wishlist_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/product_card.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
      ),
      body: Obx(() {
        final favorites = controller.favorites;
        if (favorites.isEmpty) {
          return const Center(
            child: Text('Aucun produit en favoris.'),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: favorites.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final product = favorites[index];
            return ProductCard(
              product: product,
              onTap: () => Get.toNamed(
                Routes.PRODUCT_DETAILS,
                arguments: product,
              ),
              onAddToCart: () async {
                if (!await authController.ensureLoggedIn()) return;
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
      }),
    );
  }
}
