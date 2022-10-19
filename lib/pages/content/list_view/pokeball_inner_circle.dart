import 'package:flutter/material.dart';

class PokeballInnerCircle extends StatefulWidget {
  const PokeballInnerCircle(
      {Key? key, required this.duration, required this.delay})
      : super(key: key);
  final Duration duration;
  final Duration delay;

  @override
  State<PokeballInnerCircle> createState() => _PokeballInnerCircleState();
}

class _PokeballInnerCircleState extends State<PokeballInnerCircle>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: widget.delay +
        Duration(microseconds: widget.duration.inMicroseconds ~/ 2),
    vsync: this,
  )..forward();
  late final Animation<double> _animation =
      Tween<double>(begin: 0, end: 0.5).animate(CurvedAnimation(
    parent: _controller,
    curve: Interval(
      widget.delay.inMicroseconds /
          (widget.delay + widget.duration).inMicroseconds,
      1.0,
      curve: Curves.easeInQuint,
    ),
  ));

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
    _controller.forward();
    debugPrint(
        "${widget.delay.inMicroseconds / (widget.delay + widget.duration).inMicroseconds}");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 12),
        ),
      ),
    );
  }
}
