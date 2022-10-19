import 'package:flutter/material.dart';

class DetailsHeadline extends StatelessWidget {
  const DetailsHeadline(this.text, {Key? key, this.fontSize = 32})
      : super(key: key);
  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ));
  }
}
