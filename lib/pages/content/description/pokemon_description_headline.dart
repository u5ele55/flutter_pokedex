import 'package:flutter/material.dart';
import 'package:pokedex/widgets/stroke_text.dart';

class Headline extends StatelessWidget {
  const Headline(this.text, [this.fontSize = 32, Key? key]) : super(key: key);
  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return StrokeText(
      text,
      strokeWidth: 4,
      style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
          letterSpacing: 5,
          fontFamily: "Pokemon Solid"),
      textAlign: TextAlign.center,
    );
  }
}
