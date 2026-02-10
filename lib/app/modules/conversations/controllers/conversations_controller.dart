import 'package:get/get.dart';
import '../../../data/models/conversation.dart';
import '../../../data/services/conversation_service.dart';

class ConversationsController extends GetxController {
  final ConversationService _conversationService = Get.find();

  final conversations = <Conversation>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadConversations();
  }

  Future<void> loadConversations() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      conversations.assignAll(await _conversationService.getMyConversations());
    } catch (e) {
      errorMessage.value = 'Impossible de charger les conversations.';
    } finally {
      isLoading.value = false;
    }
  }
}
