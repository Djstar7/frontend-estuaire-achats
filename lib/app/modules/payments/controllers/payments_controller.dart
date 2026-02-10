import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/payment.dart';
import '../../../data/services/payment_service.dart';

class PaymentsController extends GetxController {
  final PaymentService _paymentService = Get.find();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final payment = Rxn<Payment>();

  final TextEditingController orderIdController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  final RxString selectedMethod = 'mobile_money'.obs;

  Future<void> initiatePayment() async {
    final orderId = int.tryParse(orderIdController.text.trim());
    if (orderId == null) {
      errorMessage.value = 'ID de commande invalide.';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      payment.value = await _paymentService.initiatePayment(orderId, selectedMethod.value);
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
    super.onClose();
  }
}
