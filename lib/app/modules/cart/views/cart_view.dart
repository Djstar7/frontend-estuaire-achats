import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../data/services/order_service.dart';
import '../../../utils/formatters.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final authController = Get.find<AuthController>();
    final orderService = Get.find<OrderService>();

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
                        if (!authController.isLoggedIn) {
                          Get.snackbar(
                            'Commande',
                            'Connectez-vous pour passer commande.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }

                        final addressCtrl = TextEditingController();
                        final currencyCtrl = TextEditingController(text: 'XAF');
                        await Get.defaultDialog(
                          title: 'Passer commande',
                          content: Column(
                            children: [
                              TextField(
                                controller: addressCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Adresse de livraison',
                                ),
                              ),
                              const SizedBox(height: 12),
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
                            final address = addressCtrl.text.trim();
                            final currency = currencyCtrl.text.trim();
                            if (address.isEmpty || currency.length != 3) {
                              Get.snackbar(
                                'Commande',
                                'Adresse et devise valides requises.',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }

                            final items = cartController.cartItems
                                .map((item) => {
                                      'product_id': item.product.id,
                                      'quantity': item.quantity,
                                    })
                                .where((item) => item['product_id'] != null)
                                .toList();

                            try {
                              await orderService.createOrders({
                                'items': items,
                                'delivery_address': address,
                                'currency': currency.toUpperCase(),
                              });
                              cartController.clearCart();
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
