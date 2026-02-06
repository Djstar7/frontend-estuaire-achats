import 'package:flutter/material.dart';
import 'package:frontend_estuaire_achats/app/modules/auth/controllers/auth_controller.dart';
import 'package:frontend_estuaire_achats/app/routes/app_pages.dart';
import 'package:get/get.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<OnboardingItem> onboardingItems = [
    OnboardingItem(
      title: 'Bienvenue sur Estuaire Achats',
      description: 'Découvrez les meilleurs produits locaux à des prix imbattables.',
      imagePath: 'assets/images/onboarding1.png',
      icon: Icons.storefront_outlined,
    ),
    OnboardingItem(
      title: 'Livraison Rapide',
      description: 'Recevez vos commandes directement à votre domicile rapidement.',
      imagePath: 'assets/images/onboarding2.png',
      icon: Icons.local_shipping_outlined,
    ),
    OnboardingItem(
      title: 'Paiements Sécurisés',
      description: 'Achetez en toute confiance avec nos options de paiement sécurisées.',
      imagePath: 'assets/images/onboarding3.png',
      icon: Icons.lock_outline,
    ),
  ];

  // Handle page change
  void _handleGetStarted() {
    // Mark onboarding as completed
    final AuthController authController = Get.find<AuthController>();
    authController.setFirstTimeDone();
    // Navigate to home screen
    Get.offAllNamed(Routes.HOME);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingItems.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final item = onboardingItems[index];
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image avec fallback vers icône
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Image.asset(
                        item.imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback si l'image ne charge pas
                          return Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(40),
                            child: Icon(
                              item.icon,
                              size: 120,
                              color: Theme.of(context).primaryColor,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        item.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark ? Colors.grey[400] : Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Indicateurs de page (dots)
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingItems.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? Theme.of(context).primaryColor
                        : (isDark ? Colors.grey[700] : Colors.grey[300]),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),

          // Boutons Skip et Next/Get Started
          Positioned(
            bottom: 20,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Bouton Skip à gauche
                TextButton(
                  onPressed: () => _handleGetStarted(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Passer',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),

                // Bouton Next/Get Started à droite
                ElevatedButton(
                  onPressed: () {
                    if (currentPage < onboardingItems.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    } else {
                      _handleGetStarted();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    elevation: 2,
                  ),
                  child: Text(
                    currentPage < onboardingItems.length - 1 ? 'Suivant' : 'Commencer',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final String imagePath;
  final IconData icon;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.icon,
  });
}