import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/sticky_tabbar_widgets.dart';
import '../widgets/product_screen_components.dart';

const _tabs = [
  ('All', 'all'),
  ('Electronics', 'electronics'),
  ('Jewelery', 'jewelery'),
];

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() =>
      _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen>
    with SingleTickerProviderStateMixin {

  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _tabs.length, vsync: this);

    _tabController.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<AppProvider>();
      for (final tab in _tabs) {
        p.loadProducts(tab.$2);
      }
    });
  }

  Future<void> _onRefresh() async {
    final p = context.read<AppProvider>();
    await p.refresh(_tabs[_tabController.index].$2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final currentCategory = _tabs[_tabController.index].$2;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [

            SliverAppBar(
              expandedHeight: 140,
              pinned: true,
              backgroundColor: const Color(0xFFFF6B35),
              flexibleSpace: FlexibleSpaceBar(
                background: ProductScreenComponents.buildBanner(),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: ProductScreenComponents.buildSearchBar(),
              ),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: StickyTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  tabs: _tabs.map((t) => Tab(text: t.$1)).toList(),
                ),
              ),
            ),

            Consumer<AppProvider>(
              builder: (context, provider, _) {

                if (provider.isLoadingProductsFor(currentCategory)) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (provider.errorFor(currentCategory) != null) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(provider.errorFor(currentCategory)!),
                    ),
                  );
                }

                final products =
                provider.productsFor(currentCategory);

                return SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                          ProductCard(product: products[index]),
                      childCount: products.length,
                    ),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}