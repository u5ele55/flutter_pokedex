import 'package:flutter/material.dart';

class PokeballLoadingCircle extends StatefulWidget {
  const PokeballLoadingCircle({Key? key, this.duration = 2000})
      : super(key: key);
  final int duration;

  @override
  State<PokeballLoadingCircle> createState() => _PokeballLoadingCircleState();
}

class _PokeballLoadingCircleState extends State<PokeballLoadingCircle>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    )..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: CircularProgressIndicator(
        value: controller.value,
        valueColor: controller.drive(
          ColorTween(begin: Colors.green, end: Colors.red),
        ),
        strokeWidth: 4,
      ),
    );
  }
}
