import 'package:get/get.dart';
import '../controllers/conversation_detail_controller.dart';

class ConversationDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConversationDetailController>(() => ConversationDetailController());
  }
}
