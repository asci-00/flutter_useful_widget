import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class EmojiAnimationSample extends StatelessWidget {
  const EmojiAnimationSample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('emoji animation')),
      body: const SafeArea(
        child: Center(child: _EmojiOpenButton()),
      ),
    );
  }
}

class _EmojiOpenButton extends StatefulWidget {
  const _EmojiOpenButton();

  @override
  State<_EmojiOpenButton> createState() => _EmojiOpenButtonState();
}

class _EmojiOpenButtonState extends State<_EmojiOpenButton> {
  final _controller = OverlayPortalController();
  final _emojis = ['🥲', '😊', '👍', '❤️', '🙏'];
  final _layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: _controller,
        overlayChildBuilder: (context) => CompositedTransformFollower(
          link: _layerLink,
          targetAnchor: Alignment.bottomLeft,
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: EmojiAnimationContainer(
              emojis: _emojis.map((emoji) => _EmojiItem(emoji)).toList(),
              onTap: _controller.hide,
            ),
          ),
        ),
        child: ElevatedButton(
          onPressed: _controller.toggle,
          child: const Text('open emoji'),
        ),
      ),
    );
  }
}

class _EmojiItem extends StatelessWidget {
  const _EmojiItem(this.emoji);

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Text(emoji, style: const TextStyle(fontSize: 20));
  }
}

class EmojiAnimationContainer extends StatelessWidget {
  const EmojiAnimationContainer({
    super.key,
    required this.emojis,
    required this.onTap,
  });

  final List<Widget> emojis;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        boxShadow: [
          BoxShadow(
            offset: const Offset(1.0, 1.0),
            blurRadius: .5,
            color: Colors.black12.withOpacity(0.34),
          ),
        ],
      ),
      // padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: emojis
            .mapIndexed((index, emoji) => AnimatedEmoji(
                  emoji: emoji,
                  delay: Duration(milliseconds: 30 * index),
                  onTap: onTap,
                ))
            .toList(),
      ),
    );
  }
}

class AnimatedEmoji extends StatefulWidget {
  const AnimatedEmoji({
    super.key,
    required this.emoji,
    required this.delay,
    required this.onTap,
  });

  final Widget emoji;
  final Duration delay;
  final VoidCallback onTap;

  @override
  State<AnimatedEmoji> createState() => _AnimatedEmojiState();
}

class _AnimatedEmojiState extends State<AnimatedEmoji>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curvedAnimation;
  late final Animation<double> _emojiAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..addListener(() => setState(() {}));

    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _emojiAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_curvedAnimation);

    Timer(widget.delay, _controller.forward);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _curvedAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Transform(
        transform: Matrix4.identity()
          ..rotateX(_emojiAnimation.value - 1)
          ..rotateY(_emojiAnimation.value - 1)
          ..rotateZ(_emojiAnimation.value - 1)
          ..scale(
            _emojiAnimation.value,
            _emojiAnimation.value,
            _emojiAnimation.value,
          ),
        alignment: Alignment.center,
        child: widget.emoji,
      ),
    );
  }
}
