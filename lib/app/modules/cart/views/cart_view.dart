import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../utils/formatters.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon panier'),
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const Center(
            child: Text('Votre panier est vide.'),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: cartController.cartItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  final product = item.product;
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.shopping_bag_outlined),
                      title: Text(product.name ?? 'Produit'),
                      subtitle: Text(formatCurrency(product.price)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              final id = product.id;
                              if (id == null) return;
                              cartController.updateQuantity(id, item.quantity - 1);
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Text('${item.quantity}'),
                          IconButton(
                            onPressed: () {
                              final id = product.id;
                              if (id == null) return;
                              cartController.updateQuantity(id, item.quantity + 1);
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formatCurrency(cartController.totalPrice),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!await authController.ensureLoggedIn()) {
                          return;
                        }

                        final currencyCtrl = TextEditingController(text: 'XAF');
                        await Get.defaultDialog(
                          title: 'Passer commande',
                          content: Column(
                            children: [
                              TextField(
                                controller: currencyCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Devise (ex: XAF)',
                                ),
                              ),
                            ],
                          ),
                          textConfirm: 'Valider',
                          textCancel: 'Annuler',
                          onConfirm: () async {
                            final currency = currencyCtrl.text.trim();
                            if (currency.length != 3) {
                              Get.snackbar(
                                'Commande',
                                'Devise valide requise.',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }

                            try {
                              await cartController.createOrdersFromCart(
                                // deliveryAddress: address,
                                currency: currency.toUpperCase(),
                              );
                              Get.back();
                              Get.snackbar(
                                'Commande',
                                'Commande créée avec succès.',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            } catch (e) {
                              Get.snackbar(
                                'Commande',
                                'Impossible de créer la commande.',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                        );
                      },
                      child: const Text('Commander'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
