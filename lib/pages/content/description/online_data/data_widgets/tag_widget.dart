import 'package:flutter/material.dart';

const Map<String, Color> _tagToColor = {
  "Starter": Colors.green,
  "Legendary": Colors.amber,
  "Mythical": Colors.purple,
  "Mega": Colors.redAccent,
  "Ultra Beast": Colors.blue,
};

class PokemonTagWidget extends StatelessWidget {
  const PokemonTagWidget(this.tag, {Key? key}) : super(key: key);
  final String tag;
  @override
  Widget build(BuildContext context) {
    Color color = _tagToColor[tag] ?? Colors.black;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [color, color.withAlpha(96)],
                begin: Alignment.topRight,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                    color: color, blurRadius: 12, blurStyle: BlurStyle.outer)
              ]),
          width: 48,
          height: 48,
        ),
        const SizedBox(height: 2),
        Text(tag, style: const TextStyle(fontSize: 28))
      ],
    );
  }
}
