import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/category.dart';
import '../../../data/models/product.dart';
import '../../../data/models/seller.dart';
import '../../../data/services/api_client.dart';
import '../../../data/services/category_service.dart';
import '../../../data/services/product_service.dart';
import '../../../data/services/seller_service.dart';
import '../../../utils/formatters.dart';
import '../../../routes/app_pages.dart';

class SellerDetailsView extends StatefulWidget {
  const SellerDetailsView({super.key});

  @override
  State<SellerDetailsView> createState() => _SellerDetailsViewState();
}

class _SellerDetailsViewState extends State<SellerDetailsView> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _sectionKeys = {};

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arg = Get.arguments;
    final sellerId = arg is Seller ? arg.id : (arg is int ? arg : null);
    if (sellerId == null) {
      return const Scaffold(
        body: Center(child: Text('Vendeur introuvable.')),
      );
    }

    final sellerService = Get.find<SellerService>();
    final productService = Get.find<ProductService>();
    final categoryService = Get.find<CategoryService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Boutique'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          sellerService.getSeller(sellerId),
          productService.getProducts(sellerId: sellerId),
          categoryService.getAllCategories(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text('Impossible de charger la boutique.'),
            );
          }

          final seller = snapshot.data![0] as Seller;
          final products = snapshot.data![1] as List<Product>;
          final categories = snapshot.data![2] as List<Category>;

          final categoryMap = <int, String>{};
          void addCategory(Category category) {
            final id = category.id;
            if (id != null) {
              categoryMap[id] = category.name ?? 'Catégorie #$id';
            }
            final children = category.children ?? [];
            for (final child in children) {
              addCategory(child);
            }
          }

          for (final category in categories) {
            addCategory(category);
          }

          final grouped = <int?, List<Product>>{};
          for (final product in products) {
            grouped.putIfAbsent(product.categoryId, () => []).add(product);
          }

          final groupedEntries = grouped.entries.toList()
            ..sort((a, b) {
              final nameA = categoryMap[a.key] ?? 'Sans catégorie';
              final nameB = categoryMap[b.key] ?? 'Sans catégorie';
              return nameA.compareTo(nameB);
            });

          final categoryOrder = <int>[];
          for (final entry in groupedEntries) {
            final key = entry.key ?? -1;
            categoryOrder.add(key);
            _sectionKeys.putIfAbsent(key, () => GlobalKey());
          }

          final cover = _resolveNetworkUrl(seller.coverImageUrl);
          final logo = _resolveNetworkUrl(seller.logoUrl);

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (cover != null)
                        Image.network(
                          cover,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _coverPlaceholder(),
                        )
                      else
                        _coverPlaceholder(),
                      Positioned(
                        left: 16,
                        bottom: -30,
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: Theme.of(context).cardColor,
                          backgroundImage: logo != null ? NetworkImage(logo) : null,
                          child: logo == null
                              ? Text(
                                  seller.initials ?? 'S',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        seller.storeName ?? 'Boutique',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 6),
                      if (seller.address != null && seller.address!.isNotEmpty)
                        _InfoRow(
                          icon: Icons.location_on_outlined,
                          label: seller.address!,
                        ),
                      if (seller.phone != null && seller.phone!.isNotEmpty)
                        _InfoRow(
                          icon: Icons.phone_outlined,
                          label: seller.phone!,
                        ),
                      if (seller.ownerName != null && seller.ownerName!.isNotEmpty)
                        _InfoRow(
                          icon: Icons.person_outline,
                          label: seller.ownerName!,
                        ),
                      if (seller.ownerEmail != null && seller.ownerEmail!.isNotEmpty)
                        _InfoRow(
                          icon: Icons.email_outlined,
                          label: seller.ownerEmail!,
                        ),
                      const SizedBox(height: 12),
                      if (seller.active == false)
                        Text(
                          'Boutique inactive',
                          style: TextStyle(color: Colors.red.shade600),
                        ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              if (groupedEntries.isNotEmpty)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _CategoryTabsHeader(
                    height: 56,
                    child: _CategoryTabs(
                      categoryOrder: categoryOrder,
                      categoryMap: categoryMap,
                      onTap: (id) => _scrollToSection(id),
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              if (products.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Aucun produit disponible.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                )
              else
                ...groupedEntries.map((entry) {
                  final categoryName =
                      categoryMap[entry.key] ?? 'Sans catégorie';
                  final items = entry.value;
                  final key = _sectionKeys[entry.key ?? -1]!;

                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        key: key,
                        child: _CategorySection(
                          title: categoryName,
                          products: items,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          );
        },
      ),
    );
  }

  void _scrollToSection(int id) {
    final key = _sectionKeys[id];
    if (key == null || key.currentContext == null) return;
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      alignment: 0.1,
    );
  }

  static String? _resolveNetworkUrl(String? url) {
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

  static Widget _coverPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.storefront, size: 48, color: Colors.grey),
      ),
    );
  }
}

class _CategoryTabsHeader extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  const _CategoryTabsHeader({
    required this.height,
    required this.child,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _CategoryTabsHeader oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}

class _CategoryTabs extends StatelessWidget {
  final List<int> categoryOrder;
  final Map<int, String> categoryMap;
  final ValueChanged<int> onTap;

  const _CategoryTabs({
    required this.categoryOrder,
    required this.categoryMap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: categoryOrder.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (context, index) {
        final id = categoryOrder[index];
        final name = categoryMap[id] ?? 'Sans catégorie';
        return ActionChip(
          label: Text(name),
          onPressed: () => onTap(id),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.08),
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String title;
  final List<Product> products;

  const _CategorySection({
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final count = products.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => _showAll(context),
                child: const Text('Voir tout'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = products[index];
              return _ProductMiniCard(product: product);
            },
          ),
        ),
      ],
    );
  }

  void _showAll(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${products.length} produits',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return _ProductMiniCard(product: products[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductMiniCard extends StatelessWidget {
  final Product product;

  const _ProductMiniCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        product.images?.isNotEmpty == true ? product.images!.first : null;
    final resolved = _SellerDetailsViewState._resolveNetworkUrl(imageUrl);

    return InkWell(
      onTap: () => Get.toNamed(
        Routes.PRODUCT_DETAILS,
        arguments: product,
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: SizedBox(
                height: 110,
                width: double.infinity,
                child: resolved != null
                    ? Image.network(
                        resolved,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imagePlaceholder(),
                      )
                    : _imagePlaceholder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? 'Produit',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatCurrency(product.price),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.image, size: 32, color: Colors.grey),
      ),
    );
  }
}
