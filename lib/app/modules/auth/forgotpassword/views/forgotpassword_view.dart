
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/forgotpassword_controller.dart';
import 'package:frontend_estuaire_achats/app/modules/auth/widgets/custom_textfield.dart';

class ForgotpasswordView extends GetView<ForgotpasswordController> {
  const ForgotpasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              IconButton(
                onPressed: () => Get.back(), 
                icon: const Icon(Icons.arrow_back),
              ),

              const SizedBox(height: 40),
              Text(
                'Forgot Password',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 8),
              Text(
                'Enter your email to reset your password',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.grey[400]! : Colors.grey[600]!,
                ),
              ),

              const SizedBox(height: 40),
              // Email Textfield
              CustomTextfield(
                labelText: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                controller: controller.emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),
              Obx(() => 
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value 
                      ? null 
                      : () => controller.resetPassword(controller.emailController.text),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Reset Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
