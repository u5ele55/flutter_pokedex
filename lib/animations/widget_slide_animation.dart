import "package:flutter/material.dart";

class SlideAnimation extends StatefulWidget {
  final Offset endOffset;
  final int duration;
  final int delay;
  final Widget child;
  const SlideAnimation(
      {Key? key,
      required this.endOffset,
      required this.child,
      this.duration = 1000,
      this.delay = 0})
      : super(key: key);

  @override
  State<SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: Duration(milliseconds: widget.duration),
    vsync: this,
  )..forward();

  late final Future<Animation<Offset>> _offsetAnimation = Future.delayed(
    Duration(milliseconds: widget.delay),
    () => Tween<Offset>(
      begin: Offset.zero,
      end: widget.endOffset,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInExpo,
    )),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _offsetAnimation,
        builder: (context, AsyncSnapshot<Animation<Offset>> snapshot) {
          if (snapshot.hasData) {
            return SlideTransition(
              position: snapshot.data!,
              child: widget.child,
            );
          } else {
            return widget.child;
          }
        });
  }
}
