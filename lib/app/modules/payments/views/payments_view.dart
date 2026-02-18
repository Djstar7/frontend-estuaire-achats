import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/payments_controller.dart';
import '../../../utils/formatters.dart';

class PaymentsView extends GetView<PaymentsController> {
  const PaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiements'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Initier un paiement',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.orderIdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'ID de commande',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.deliveryAddressController,
              decoration: const InputDecoration(
                labelText: 'Adresse de livraison',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.deliveryZoneController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Zone de livraison (ID, optionnel)',
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              return DropdownButtonFormField<String>(
                value: controller.selectedMethod.value,
                items: const [
                  DropdownMenuItem(
                    value: 'freemopay',
                    child: Text('FreeMoPay'),
                  ),
                  DropdownMenuItem(
                    value: 'paypal',
                    child: Text('PayPal'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) controller.selectedMethod.value = value;
                },
                decoration: const InputDecoration(labelText: 'Méthode'),
              );
            }),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.selectedMethod.value != 'freemopay') {
                return const SizedBox.shrink();
              }
              return TextField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Téléphone (FreeMoPay)',
                ),
              );
            }),
            const SizedBox(height: 12),
            Obx(() {
              final order = controller.order.value;
              if (order == null) {
                return const SizedBox.shrink();
              }
              return Text(
                'Total: ${formatCurrency(order.totalAmount)} (${order.currency ?? 'N/A'})',
              );
            }),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.initiatePayment,
                child: const Text('Initier'),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Vérifier un paiement',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.referenceController,
              decoration: const InputDecoration(
                labelText: 'Référence',
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: controller.checkStatus,
                child: const Text('Vérifier'),
              ),
            ),
            const SizedBox(height: 24),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.isNotEmpty) {
                return Text(
                  controller.errorMessage.value,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                );
              }

              final payment = controller.payment.value;
              if (payment == null) {
                return const SizedBox.shrink();
              }

              return Card(
                child: ListTile(
                  title: Text('Paiement ${payment.reference ?? ''}'),
                  subtitle: Text('Statut: ${payment.status ?? 'N/A'}'),
                  trailing: Text(formatCurrency(payment.amount)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
