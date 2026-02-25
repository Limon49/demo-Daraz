// lib/widgets/sticky_tab_bar_delegate.dart
import 'package:flutter/material.dart';

// SliverPersistentHeaderDelegate implementation for the sticky tab bar.
// minExtent == maxExtent means it never shrinks — it just pins.
class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const StickyTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return Material(
      elevation: overlapsContent ? 4 : 0,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(StickyTabBarDelegate oldDelegate) =>
      tabBar != oldDelegate.tabBar;
}