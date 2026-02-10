import 'package:flutter/material.dart';
import 'package:frontend_estuaire_achats/app/modules/auth/controllers/auth_controller.dart';
import 'package:frontend_estuaire_achats/app/modules/cart/controllers/cart_controller.dart';
import 'package:frontend_estuaire_achats/app/modules/home/controllers/home_controller.dart';
import 'package:frontend_estuaire_achats/app/modules/home/widgets/category_chips.dart';
import 'package:frontend_estuaire_achats/app/modules/home/widgets/custom_search.dart';
import 'package:frontend_estuaire_achats/app/modules/home/widgets/horizontal_product_list.dart';
import 'package:frontend_estuaire_achats/app/modules/home/widgets/sale_banner.dart';
import 'package:frontend_estuaire_achats/app/modules/home/widgets/seller_avatar_section.dart';
import 'package:frontend_estuaire_achats/app/modules/home/widgets/statistics_section.dart';
import 'package:frontend_estuaire_achats/app/modules/products/controllers/products_controller.dart';
import 'package:frontend_estuaire_achats/app/routes/app_pages.dart';
import 'package:get/get.dart';
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final HomeController homeController = Get.find<HomeController>();
    final ProductsController productsController = Get.find<ProductsController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Obx(() {
                      bool isLoggedIn = Get.find<AuthController>().isLoggedIn;
                      return CircleAvatar(
                        radius: 25,
                        backgroundImage: isLoggedIn
                            ? const AssetImage('assets/images/logo.png')
                            : null,
                        backgroundColor: isLoggedIn
                            ? Colors.white
                            : Theme.of(context).primaryColor.withOpacity(0.1),
                        child: isLoggedIn
                            ? null
                            : Icon(
                                Icons.person_outline,
                                color: Theme.of(context).primaryColor,
                              ),
                      );
                    }),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            final authController = Get.find<AuthController>();
                            return Text(
                              authController.isLoggedIn
                                ? 'Bonjour ${homeController.getUserName()}' 
                                : 'Bonjour',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            );
                          }),
                          Text(
                            homeController.getGreeting(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Theme button - assuming you have a theme controller
                    IconButton(
                      onPressed: () {
                        // Toggle theme logic would go here
                        Get.changeThemeMode(
                          Theme.of(context).brightness == Brightness.light
                            ? ThemeMode.dark
                            : ThemeMode.light
                        );
                      },
                      icon: Icon(
                        Theme.of(context).brightness == Brightness.light
                            ? Icons.dark_mode
                            : Icons.light_mode,
                      ),
                    ),
                    // Show login button if not logged in, otherwise show cart
                    // Cart button with badge
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () => Get.toNamed(Routes.CART),
                          icon: const Icon(Icons.shopping_bag_outlined),
                        ),
                        Obx(() {
                          if (cartController.itemCount == 0) {
                            return const SizedBox.shrink();
                          }
                          return Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Text(
                                '${cartController.itemCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Search
                CustomSearch(
                  onChanged: productsController.setSearchQuery,
                ),

                const SizedBox(height: 16),

                // Categories chips
                CategoryChips(),

                const SizedBox(height: 16),

                // Sale banner
                SaleBanner(),

                const SizedBox(height: 16),

                // Popular products header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Produits Populaires',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.PRODUCTS),
                      child: Text(
                        'Voir tout',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Horizontal scrollable product list
                HorizontalProductList(limit: 10),

                const SizedBox(height: 24),

                // Statistics section
                StatisticsSection(),

                const SizedBox(height: 24),

                // Top sellers section with avatars
                SellerAvatarSection(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
