import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor, // Use primary color from theme
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or branding
            Container(
              padding: const EdgeInsets.all(15), // Espace autour du logo
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle, // Ou RoundedRectangleBorder
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Image.asset(
                "assets/images/logo.png",
                height: 90, // Un peu plus petit pour tenir dans le cercle
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Estuaire Achats',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
