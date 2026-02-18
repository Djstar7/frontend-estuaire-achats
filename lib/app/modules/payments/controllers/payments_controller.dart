import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/order.dart';
import '../../../data/models/payment.dart';
import '../../../data/services/order_service.dart';
import '../../../data/services/payment_service.dart';

class PaymentsController extends GetxController {
  final PaymentService _paymentService = Get.find();
  final OrderService _orderService = Get.find();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final payment = Rxn<Payment>();
  final order = Rxn<Order>();

  final TextEditingController orderIdController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController deliveryAddressController = TextEditingController();
  final TextEditingController deliveryZoneController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final RxString selectedMethod = 'freemopay'.obs;

  Future<void> initiatePayment() async {
    final orderId = int.tryParse(orderIdController.text.trim());
    if (orderId == null) {
      errorMessage.value = 'ID de commande invalide.';
      return;
    }

    final deliveryAddress = deliveryAddressController.text.trim();
    if (deliveryAddress.isEmpty) {
      errorMessage.value = 'Adresse de livraison requise.';
      return;
    }

    final phone = phoneController.text.trim();
    if (selectedMethod.value == 'freemopay' && phone.isEmpty) {
      errorMessage.value = 'Numéro requis pour FreeMoPay.';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedOrder = await _orderService.getOrder(orderId);
      order.value = fetchedOrder;

      final amount = fetchedOrder.totalAmount ?? 0;
      final currency = fetchedOrder.currency ?? '';
      if (amount <= 0 || currency.length != 3) {
        errorMessage.value = 'Commande invalide pour paiement.';
        return;
      }

      final zoneId = int.tryParse(deliveryZoneController.text.trim());
      payment.value = await _paymentService.initiatePayment(
        orderId: orderId,
        gateway: selectedMethod.value,
        amount: amount,
        currency: currency.toUpperCase(),
        deliveryAddress: deliveryAddress,
        deliveryZoneId: zoneId,
        phone: phone.isNotEmpty ? phone : null,
      );
    } catch (e) {
      errorMessage.value = 'Impossible d\'initier le paiement.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkStatus() async {
    final reference = referenceController.text.trim();
    if (reference.isEmpty) {
      errorMessage.value = 'Référence invalide.';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      payment.value = await _paymentService.getPaymentStatus(reference);
    } catch (e) {
      errorMessage.value = 'Impossible de récupérer le statut.';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    orderIdController.dispose();
    referenceController.dispose();
    deliveryAddressController.dispose();
    deliveryZoneController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
