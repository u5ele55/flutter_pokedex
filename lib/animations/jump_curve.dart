import 'package:flutter/animation.dart';

class JumpCurve extends Curve {
  @override
  double transformInternal(double t) {
    if (t == 0) return t;
    return 1;
  }
}
