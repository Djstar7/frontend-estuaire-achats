import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/categories_controller.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catégories'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.categories.isEmpty) {
          return const Center(child: Text('Aucune catégorie disponible.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.categories.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.category_outlined),
                title: Text(category.name ?? 'Catégorie'),
                subtitle: Text('ID: ${category.id ?? ''}'),
              ),
            );
          },
        );
      }),
    );
  }
}
