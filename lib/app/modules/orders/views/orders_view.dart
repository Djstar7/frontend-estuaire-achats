import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/order.dart';
import '../../../data/services/order_service.dart';
import '../../../utils/formatters.dart';
import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes commandes'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.orders.isEmpty) {
          return const Center(child: Text('Aucune commande disponible.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: Text('Commande #${order.id ?? ''}'),
                subtitle: Text('Statut: ${order.status ?? 'N/A'}'),
                trailing: Text(formatCurrency(order.totalAmount)),
                onTap: () => _openOrderDetails(context, order),
              ),
            );
          },
        );
      }),
    );
  }

  void _openOrderDetails(BuildContext context, Order order) {
    final orderService = Get.find<OrderService>();
    final id = order.id;
    if (id == null) return;

    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<Order>(
                future: orderService.getOrder(id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(
                      child: Text('Impossible de charger la commande.'),
                    );
                  }

                  final data = snapshot.data!;
                  final items = data.items ?? [];

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        'Commande #${data.id ?? ''}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text('Statut: ${data.status ?? 'N/A'}'),
                      if (data.deliveryAddress != null) ...[
                        const SizedBox(height: 8),
                        Text('Adresse: ${data.deliveryAddress}'),
                      ],
                      if (data.notes != null && data.notes!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text('Notes: ${data.notes}'),
                      ],
                      const SizedBox(height: 16),
                      Text(
                        'Articles',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      if (items.isEmpty)
                        const Text('Aucun article.')
                      else
                        ...items.map((item) {
                          final name = item.product?.name ?? 'Produit';
                          final qty = item.quantity ?? 0;
                          final lineTotal = item.totalPrice ??
                              (item.unitPrice ?? 0) * qty;
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(name),
                            subtitle: Text('Qté: $qty'),
                            trailing: Text(formatCurrency(lineTotal)),
                          );
                        }).toList(),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            formatCurrency(data.totalAmount),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
