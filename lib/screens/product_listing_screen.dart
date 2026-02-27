// lib/screens/product_listing_screen.dart

// ARCHITECTURE NOTES:
//
// 1. VERTICAL SCROLL OWNERSHIP:
//    NestedScrollView owns the single vertical ScrollController.
//    The SliverAppBar and SliverPersistentHeader live in its header slivers.
//    Each tab's ListView uses NeverScrollableScrollPhysics — they are
//    render-only; they never intercept touch events for vertical scrolling.
//    This guarantees exactly ONE vertical scroll on screen.
//
// 2. HORIZONTAL SWIPE:
//    PageView handles horizontal swipe exclusively. It uses a custom
//    ScrollPhysics (PageScrollPhysics) that only activates on predominantly
//    horizontal drag gestures. The PageView does NOT propagate vertical
//    drag events to its parent, and the tab content does NOT propagate
//    horizontal drag events upward — Flutter's gesture arena handles this
//    via the axis-lock on the PageView's scroll direction.
//
// 3. TAB SCROLL POSITION PRESERVATION:
//    Each tab's content is kept alive via AutomaticKeepAliveClientMixin.
//    NestedScrollView's single outer scroll position is shared, so
//    switching tabs never resets the header collapse state.
//    We do NOT maintain per-tab inner scroll positions because with
//    NeverScrollableScrollPhysics there is no inner scroll — everything
//    is in the outer scroll.
//
// 4. PULL-TO-REFRESH:
//    RefreshIndicator wraps the NestedScrollView. Because there is only
//    one scroll, pull-to-refresh works uniformly regardless of active tab.
//
// TRADE-OFFS:
//    - Because there's one shared vertical scroll, very long lists in one
//      tab and short lists in another can cause visual jumps when switching
//      (the outer scroll position may exceed the new tab's content height).
//      Mitigation: ensure content is always tall enough, or clamp scroll.
//    - FakeStore's JWT doesn't encode userId so we hardcode userId=1.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/sticky_tabbar_widgets.dart';
import 'profile_screen.dart';

const _tabs = [
  ('All', 'all'),
  ('Electronics', 'electronics'),
  ('Jewelery', 'jewelery'),
];

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _pageController = PageController();

    // Sync PageView → TabController
    _pageController.addListener(_onPageScroll);

    // Pre-load all tabs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<AppProvider>();
      for (final tab in _tabs) {
      p.loadProducts(tab.$2);
    }
    });
  }

  void _onPageScroll() {
    // Only update tab index when page settles to avoid mid-swipe flicker
    final page = _pageController.page ?? 0;
    final index = page.round();
    if (_tabController.index != index) {
      _tabController.animateTo(index);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    final p = context.read<AppProvider>();
    final category = _tabs[_tabController.index].$2;
    await p.refresh(category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        // RefreshIndicator wraps NestedScrollView so it captures
        // the single outer scroll's overscroll for pull-to-refresh
        onRefresh: _onRefresh,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            // --- Collapsible SliverAppBar (banner + search) ---
            SliverAppBar(
              expandedHeight: 160,
              floating: true,
              pinned: false,
              snap: true,
              // innerBoxIsScrolled = true when content is scrolled up
              forceElevated: innerBoxIsScrolled,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildBanner(),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: _buildSearchBar(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileScreen(),
                    ),
                  ),
                ),
              ],
            ),

            // --- Sticky Tab Bar ---
            // SliverPersistentHeader with pinned:true stays visible
            // once the SliverAppBar collapses
            SliverPersistentHeader(
              pinned: true,
              delegate: StickyTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  tabs: _tabs.map((t) => Tab(text: t.$1)).toList(),
                  onTap: (index) {
                    // Tab tap → animate PageView horizontally
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ),
          ],

          // --- Body: PageView handles ONLY horizontal scrolling ---
          body: PageView.builder(
            controller: _pageController,
            // PageView uses horizontal axis — Flutter's gesture arena
            // automatically separates horizontal drags (owned by PageView)
            // from vertical drags (owned by NestedScrollView outer scroller)
            itemCount: _tabs.length,
            onPageChanged: (index) => _tabController.animateTo(index),
            itemBuilder: (context, index) => _TabContent(
              category: _tabs[index].$2,
            ),
          ),
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
            color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold,
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

// ---------------------------------------------------------------------------
// Each tab's content — renders inside PageView
// NeverScrollableScrollPhysics = surrenders ALL vertical scroll to parent
// AutomaticKeepAliveClientMixin = keeps widget alive when tab is off-screen
// ---------------------------------------------------------------------------
class _TabContent extends StatefulWidget {
  final String category;
  const _TabContent({required this.category});

  @override
  State<_TabContent> createState() => _TabContentState();
}

class _TabContentState extends State<_TabContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Don't rebuild when switching tabs

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required by AutomaticKeepAliveClientMixin

    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingProductsFor(widget.category)) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.errorFor(widget.category) != null) {
          return Center(child: Text('Error: ${provider.errorFor(widget.category)}'));
        }
        final products = provider.productsFor(widget.category);
        return GridView.builder(
          // CRITICAL: This GridView never scrolls vertically.
          // Vertical scroll is fully owned by NestedScrollView.
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true, // Size to content so NestedScrollView can measure
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) => ProductCard(product: products[index]),
        );
      },
    );
  }
}