import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/conversation.dart';
import '../../../data/models/message.dart';
import '../../../data/services/message_service.dart';

class ConversationDetailController extends GetxController {
  final MessageService _messageService = Get.find();

  final messages = <Message>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final TextEditingController messageController = TextEditingController();

  int? get conversationId {
    final idParam = Get.parameters['id'];
    if (idParam == null) return null;
    return int.tryParse(idParam);
  }

  Conversation? get conversation => Get.arguments as Conversation?;

  @override
  void onInit() {
    super.onInit();
    loadMessages();
  }

  Future<void> loadMessages() async {
    final id = conversationId;
    if (id == null) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      messages.assignAll(await _messageService.getMessages(id));
    } catch (e) {
      errorMessage.value = 'Impossible de charger les messages.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final id = conversationId;
    final content = messageController.text.trim();
    if (id == null || content.isEmpty) return;

    try {
      final message = await _messageService.sendMessage(id, content);
      messages.insert(0, message);
      messageController.clear();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible d\'envoyer le message.');
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
