import 'package:flutter/material.dart';
import 'package:sample/features/emoji_animation.dart';
import 'package:sample/features/fade_in_title.dart';

void main() => runApp(const NestedScrollViewExampleApp());

class NestedScrollViewExampleApp extends StatelessWidget {
  const NestedScrollViewExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FlutterUsefulWidgetPage(),
    );
  }
}

class _PageInfo {
  const _PageInfo({
    required this.title,
    required this.page,
  });

  final String title;
  final Widget page;
}

class FlutterUsefulWidgetPage extends StatelessWidget {
  const FlutterUsefulWidgetPage({super.key});

  static const _pages = [
    _PageInfo(
      title: 'FadeInTitle',
      page: FadeInTitleSample(),
    ),
    _PageInfo(
      title: 'EmojiAnimation',
      page: EmojiAnimationSample(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Useful Widget')),
      body: ListView.builder(
        itemBuilder: (context, index) => ListTile(
          title: Text(
            _pages[index].title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => _pages[index].page)),
        ),
        itemCount: _pages.length,
      ),
    );
  }
}
