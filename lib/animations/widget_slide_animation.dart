import "package:flutter/material.dart";

class SlideAnimation extends StatefulWidget {
  final Offset endOffset;
  final Duration duration;
  final Duration delay;
  final Widget child;
  final bool destroyAfterCompletion;
  final bool reverse;
  const SlideAnimation(
      {Key? key,
      required this.endOffset,
      required this.child,
      required this.duration,
      required this.delay,
      this.destroyAfterCompletion = false,
      this.reverse = false})
      : super(key: key);

  @override
  State<SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  bool _isShown = true;

  late final AnimationController _controller = AnimationController(
    duration: widget.duration + widget.delay,
    vsync: this,
  )..forward().whenComplete(() => setState(
        () => _isShown = false || !widget.destroyAfterCompletion,
      ));

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: !widget.reverse ? Offset.zero : widget.endOffset,
    end: !widget.reverse ? widget.endOffset : Offset.zero,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Interval(
      widget.delay.inMicroseconds /
          (widget.delay + widget.duration).inMicroseconds,
      1.0,
    ),
  ));

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isShown
        ? SlideTransition(
            position: _offsetAnimation,
            child: widget.child,
          )
        : const SizedBox.shrink();
  }
}
