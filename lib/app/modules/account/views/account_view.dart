import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon compte'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(authController.userName.isNotEmpty
                  ? authController.userName
                  : 'Utilisateur'),
              subtitle: Text(authController.userEmail.isNotEmpty
                  ? authController.userEmail
                  : 'Connectez-vous pour accéder à votre compte'),
              trailing: TextButton(
                onPressed: () => Get.toNamed(Routes.LOGIN),
                child: Text(authController.isLoggedIn ? 'Profil' : 'Se connecter'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Services',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.shopping_basket_outlined),
                  title: const Text('Mes commandes'),
                  onTap: () => Get.toNamed(Routes.ORDERS),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.chat_bubble_outline),
                  title: const Text('Conversations'),
                  onTap: () => Get.toNamed(Routes.CONVERSATIONS),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.payments_outlined),
                  title: const Text('Paiements'),
                  onTap: () => Get.toNamed(Routes.PAYMENTS),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
