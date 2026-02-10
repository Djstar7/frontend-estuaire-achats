import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/seller.dart';
import '../../../data/services/api_client.dart';
import '../controllers/home_controller.dart';
import '../../../routes/app_pages.dart';

class SellerAvatarSection extends StatelessWidget {
  const SellerAvatarSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final sellers = controller.topSellers;
      if (controller.isLoadingTopSellers.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.topSellersError.value.isNotEmpty) {
        return Text(
          controller.topSellersError.value,
          style: TextStyle(color: Colors.grey[600]),
        );
      }
      if (sellers.isEmpty) {
        return Text(
          'Aucun vendeur disponible.',
          style: TextStyle(color: Colors.grey[600]),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Meilleurs vendeurs',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: sellers.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final seller = sellers[index];
                return _SellerAvatar(
                  seller: seller,
                  onTap: () => Get.toNamed(
                    Routes.SELLER_DETAILS,
                    arguments: seller,
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

class _SellerAvatar extends StatelessWidget {
  final Seller seller;
  final VoidCallback onTap;

  const _SellerAvatar({required this.seller, required this.onTap});

  String? _resolveNetworkUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('http')) return url;
    if (url.startsWith('assets/')) return null;

    final apiClient = Get.find<ApiClient>();
    var base = apiClient.baseUrl;
    final apiIndex = base.indexOf('/api/');
    if (apiIndex != -1) {
      base = base.substring(0, apiIndex);
    }
    if (base.endsWith('/')) {
      base = base.substring(0, base.length - 1);
    }
    final path = url.startsWith('/') ? url : '/$url';
    return '$base$path';
  }

  @override
  Widget build(BuildContext context) {
    final logoUrl = _resolveNetworkUrl(seller.logoUrl);
    final coverUrl = _resolveNetworkUrl(seller.coverImageUrl);
    final initials = seller.initials ?? 'S';
    final orders = seller.ordersCount ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 140,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
                image: coverUrl != null
                    ? DecorationImage(
                        image: NetworkImage(coverUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: coverUrl == null
                  ? const Center(
                      child: Icon(Icons.storefront, color: Colors.grey),
                    )
                  : null,
            ),
            const SizedBox(height: 8),
            CircleAvatar(
              radius: 22,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              backgroundImage: logoUrl != null ? NetworkImage(logoUrl) : null,
              child: logoUrl == null
                  ? Text(
                      initials,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 6),
            Text(
              seller.storeName ?? 'Vendeur',
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.storefront,
                  color: Colors.amber,
                  size: 12,
                ),
                const SizedBox(width: 2),
                Text(
                  '$orders ventes',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
