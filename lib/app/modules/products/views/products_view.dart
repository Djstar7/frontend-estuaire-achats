import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/widgets/custom_search.dart';
import '../../../widgets/product_grid.dart';
import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tous les produits'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomSearch(
              onChanged: controller.setSearchQuery,
            ),
          ),
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
