import 'package:get/get.dart';
import '../controllers/api_settings_controller.dart';

class ApiSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiSettingsController>(() => ApiSettingsController());
  }
}
