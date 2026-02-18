import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
          return const Center(
            child: Text('Aucune conversation pour le moment.'),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.conversations.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final conversation = controller.conversations[index];
            final title =
                conversation.seller?.name ?? conversation.buyer?.name ?? 'Conversation';
            final subtitle = conversation.lastMessage ?? 'Aucun message';
            final lastAt = conversation.lastMessageAt;
            final timeLabel = lastAt != null
                ? DateFormat('dd/MM • HH:mm').format(lastAt)
                : '';

            return Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: const Icon(Icons.storefront_outlined),
                ),
                title: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (timeLabel.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          timeLabel,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
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
