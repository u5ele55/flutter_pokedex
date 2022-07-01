import 'package:flutter/material.dart';

class CircleLoading extends StatelessWidget {
  const CircleLoading({this.size = 24, Key? key}) : super(key: key);
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: const CircularProgressIndicator(strokeWidth: 1.5),
      ),
    );
  }
}
