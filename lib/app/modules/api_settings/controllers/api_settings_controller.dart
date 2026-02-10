import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_client.dart';

class ApiSettingsController extends GetxController {
  final ApiClient _apiClient = Get.find();
  final TextEditingController baseUrlController = TextEditingController();
  final currentBaseUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    currentBaseUrl.value = _apiClient.baseUrl;
    baseUrlController.text = currentBaseUrl.value;
  }

  Future<void> save() async {
    final value = baseUrlController.text.trim();
    await _apiClient.setBaseUrl(value.isEmpty ? null : value);
    currentBaseUrl.value = _apiClient.baseUrl;
  }

  Future<void> reset() async {
    await _apiClient.setBaseUrl(null);
    currentBaseUrl.value = _apiClient.baseUrl;
    baseUrlController.text = currentBaseUrl.value;
  }

  @override
  void onClose() {
    baseUrlController.dispose();
    super.onClose();
  }
}
