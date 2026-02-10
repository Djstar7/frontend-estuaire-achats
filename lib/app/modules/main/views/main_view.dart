import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/views/home_view.dart';
import '../../shopping/views/shopping_view.dart';
import '../../wishlist/views/wishlist_view.dart';
import '../../account/views/account_view.dart';
import '../controllers/main_controller.dart';
import '../../../widgets/custom_bottom_navbar.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            HomeView(),
            ShoppingView(),
            WishlistView(),
            AccountView(),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavbar(),
    );
  }
}
