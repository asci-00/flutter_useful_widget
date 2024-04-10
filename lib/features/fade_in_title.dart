import 'package:flutter/material.dart';

class FadeInTitleSample extends StatelessWidget {
  const FadeInTitleSample({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = ['Tab 1', 'Tab 2'];

    return Scaffold(
      body: DefaultTabController(
        length: tabs.length,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverPersistentHeader(
                  pinned: true,
                  delegate: SimpleFadeInTitleDelegate(
                    title: 'Sample Fade in Title',
                    fadeInPosition: 80.0,
                    viewBottomPadding: MediaQuery.of(context).viewPadding.top,
                    backgroundColor: Colors.blueGrey,
                    bottom: TabBar(
                      tabs: tabs.map((String name) => Tab(text: name)).toList(),
                    ),
                    body: Image.network(
                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: tabs
                .map(
                  (String name) => ColoredBox(
                    color: Colors.white,
                    child: Builder(
                      builder: (BuildContext context) {
                        return CustomScrollView(
                          key: PageStorageKey<String>(name),
                          slivers: <Widget>[
                            SliverOverlapInjector(
                              handle: NestedScrollView
                                  .sliverOverlapAbsorberHandleFor(
                                context,
                              ),
                            ),
                            SliverPadding(
                              padding: const EdgeInsets.all(8.0),
                              sliver: SliverFixedExtentList(
                                itemExtent: 48.0,
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) =>
                                      ListTile(title: Text('Item $index')),
                                  childCount: 30,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class SimpleFadeInTitleDelegate extends SliverPersistentHeaderDelegate {
  const SimpleFadeInTitleDelegate({
    required this.title,
    required this.body,
    required this.viewBottomPadding,
    this.fadeInPosition,
    this.backgroundColor,
    this.bottom,
  });

  final String title;
  final Widget body;
  final double viewBottomPadding;
  final double? fadeInPosition;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;

  static const _defaultFadeInPosition = 100.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double height = maxExtent - minExtent - shrinkOffset;
    final double resolvedHeight = height < 0 ? 0 : height;
    final double opacity = resolvedHeight < _fadeInPosition
        ? (_fadeInPosition - resolvedHeight) / _fadeInPosition
        : 0.0;

    return ColoredBox(
      color: backgroundColor ?? Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            toolbarHeight: kToolbarHeight,
            title: Text(
              title,
              style: TextStyle(
                color: Colors.black.withOpacity(opacity),
              ),
            ),
          ),
          Opacity(
            opacity: 1.0 - opacity,
            child: Container(
              height: resolvedHeight,
              color: Colors.amber,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: body,
              ),
            ),
          ),
          if (bottom != null) bottom!,
        ],
      ),
    );
  }

  double get _bottomHeight => bottom?.preferredSize.height ?? 0;

  double get _fadeInPosition => fadeInPosition ?? _defaultFadeInPosition;

  @override
  double get maxExtent => 300 + kToolbarHeight + _bottomHeight;

  @override
  double get minExtent => kToolbarHeight + viewBottomPadding + _bottomHeight;

  @override
  bool shouldRebuild(covariant SimpleFadeInTitleDelegate oldDelegate) =>
      title != oldDelegate.title ||
      body != oldDelegate.body ||
      viewBottomPadding != oldDelegate.viewBottomPadding ||
      fadeInPosition != oldDelegate.fadeInPosition ||
      backgroundColor != oldDelegate.backgroundColor ||
      bottom != oldDelegate.bottom;
}
