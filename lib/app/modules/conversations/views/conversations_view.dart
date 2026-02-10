import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/conversations_controller.dart';
import '../../../routes/app_pages.dart';

class ConversationsView extends GetView<ConversationsController> {
  const ConversationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.conversations.isEmpty) {
          return const Center(child: Text('Aucune conversation.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.conversations.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final conversation = controller.conversations[index];
            final title = conversation.seller?.name ?? conversation.buyer?.name ?? 'Conversation';
            final subtitle = conversation.lastMessage ?? 'Aucun message';

            return Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.chat_bubble_outline)),
                title: Text(title),
                subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: conversation.id == null
                    ? null
                    : () => Get.toNamed(
                          '${Routes.CONVERSATION_DETAIL}/${conversation.id}',
                          arguments: conversation,
                        ),
              ),
            );
          },
        );
      }),
    );
  }
}
