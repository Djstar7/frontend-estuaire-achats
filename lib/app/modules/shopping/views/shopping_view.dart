import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/widgets/category_chips.dart';
import '../../home/widgets/custom_search.dart';
import '../../products/controllers/products_controller.dart';
import '../../../widgets/filter_button_sheet.dart';
import '../../../widgets/product_grid.dart';

class ShoppingView extends StatelessWidget {
  const ShoppingView({super.key});

  @override
  Widget build(BuildContext context) {
    final productsController = Get.find<ProductsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Boutique'),
        actions: [
          IconButton(
            onPressed: () => FilterButtonSheet.show(context),
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomSearch(
              onChanged: productsController.setSearchQuery,
            ),
          ),
          const SizedBox(height: 8),
          const CategoryChips(),
          const Expanded(
            child: SingleChildScrollView(
              child: ProductGrid(),
            ),
          ),
        ],
      ),
    );
  }
}
