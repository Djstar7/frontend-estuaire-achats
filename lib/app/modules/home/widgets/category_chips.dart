import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../products/controllers/products_controller.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsController = Get.find<ProductsController>();

    return SizedBox(
      height: 40,
      child: Obx(() {
        final categories = productsController.categories;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length + 1,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            if (index == 0) {
              final isSelected = productsController.selectedCategoryId.value == null;
              return ChoiceChip(
                label: Text('Tous',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                selected: isSelected,
                onSelected: (_) => productsController.setSelectedCategory(null),
                selectedColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              );
            }

            final category = categories[index - 1];
            final isSelected =
                productsController.selectedCategoryId.value == category.id;
            return ChoiceChip(
              label: Text(
                category.name ?? 'Catégorie',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              selected: isSelected,
              onSelected: (_) => productsController.setSelectedCategory(category.id),
              selectedColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color: Colors.white,
              ),
            );
          },
        );
      }),
    );
  }
}
