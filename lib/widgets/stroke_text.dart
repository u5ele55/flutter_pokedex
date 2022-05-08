import 'package:flutter/material.dart';

class StrokeText extends StatelessWidget {
  const StrokeText(this.text,
      {Key? key,
      TextStyle? style,
      this.strokeWidth = 2,
      this.strokeColor = Colors.black})
      : style = style ?? const TextStyle(fontSize: 16, color: Colors.white),
        super(key: key);

  final String text;
  final TextStyle style;
  final double strokeWidth;
  final Color strokeColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Stroked text as border.
        Text(
          text,
          style: style.merge(
            TextStyle(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = strokeWidth
                ..color = strokeColor,
            ),
          ),
        ),
        // Solid text as fill.
        Text(text, style: style),
      ],
    );
  }
}
