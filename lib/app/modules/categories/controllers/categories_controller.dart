import 'package:get/get.dart';
import '../../../data/models/category.dart';
import '../../../data/services/category_service.dart';

class CategoriesController extends GetxController {
  final CategoryService _categoryService = Get.find();

  final categories = <Category>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      categories.assignAll(await _categoryService.getAllCategories());
    } catch (e) {
      errorMessage.value = 'Impossible de charger les catégories.';
    } finally {
      isLoading.value = false;
    }
  }
}
