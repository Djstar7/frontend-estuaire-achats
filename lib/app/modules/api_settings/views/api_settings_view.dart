import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/api_settings_controller.dart';

class ApiSettingsView extends GetView<ApiSettingsController> {
  const ApiSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Base URL',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.baseUrlController,
              decoration: const InputDecoration(
                labelText: 'URL API',
                hintText: 'http://127.0.0.1:8000/api/v1',
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              return Text(
                'URL active: ${controller.currentBaseUrl.value}',
                style: Theme.of(context).textTheme.bodySmall,
              );
            }),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await controller.save();
                      Get.snackbar('API', 'URL mise à jour.');
                    },
                    child: const Text('Enregistrer'),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () async {
                    await controller.reset();
                    Get.snackbar('API', 'URL réinitialisée.');
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
