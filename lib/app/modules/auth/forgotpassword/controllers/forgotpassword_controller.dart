import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotpasswordController extends GetxController {
  var isLoading = false.obs;
  var email = ''.obs;
  final TextEditingController emailController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> resetPassword(String emailInput) async {
    if (isLoading.value) return;

    isLoading(true);
    email.value = emailInput;

    try {
      // TODO: Implement actual password reset API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      // Success handling
      Get.snackbar(
        'Succès',
        'Un lien de réinitialisation du mot de passe a été envoyé à votre adresse e-mail.',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate back or to login screen
      Get.back();
    } catch (error) {
      Get.snackbar(
        'Erreur',
        'Échec de l\'envoi de l\'e-mail de réinitialisation du mot de passe. Veuillez réessayer.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
}
