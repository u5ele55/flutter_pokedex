import 'package:flutter/material.dart';

class SizeExpandingAnimation extends StatefulWidget {
  const SizeExpandingAnimation({Key? key, required this.child, duration})
      : duration = duration ?? const Duration(milliseconds: 1000),
        super(key: key);

  final Widget child;
  final Duration duration;

  @override
  State<SizeExpandingAnimation> createState() => _SizeExpandingAnimationState();
}

class _SizeExpandingAnimationState extends State<SizeExpandingAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: widget.duration,
    vsync: this,
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
