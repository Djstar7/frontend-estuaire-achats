import 'package:frontend_estuaire_achats/app/data/services/auth_service.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find();
  final AuthController _authController = Get.find();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final user = await _authService.login(email, password);
      _authController.login(name: user.name, email: user.email);
      return true;
    } catch (e) {
      errorMessage.value = 'Connexion impossible. Vérifiez vos identifiants.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
