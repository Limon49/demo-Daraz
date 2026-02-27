import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/sticky_tabbar_widgets.dart';

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
  late final PageController _pageController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _tabs.length, vsync: this);
    _pageController = PageController();

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
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
                background: _buildBanner(),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: _buildSearchBar(),
              ),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: StickyTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  tabs: _tabs.map((t) => Tab(text: t.$1)).toList(),
                  onTap: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ),

            SliverFillRemaining(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) =>
                    _tabController.animateTo(index),
                itemCount: _tabs.length,
                itemBuilder: (context, index) {
                  return _TabContent(
                    category: _tabs[index].$2,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE2231A), Color(0xFFFF6B35)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Text(
          '🛍️ Daraz Sale',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _TabContent extends StatelessWidget {

  final String category;

  const _TabContent({required this.category});

  @override
  Widget build(BuildContext context) {

    return Consumer<AppProvider>(
      builder: (context, provider, _) {

        if (provider.isLoadingProductsFor(category)) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorFor(category) != null) {
          return Center(child: Text(provider.errorFor(category)!));
        }

        final products = provider.productsFor(category);

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) =>
              ProductCard(product: products[index]),
        );
      },
    );
  }
}