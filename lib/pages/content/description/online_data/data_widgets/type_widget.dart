import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_data.dart';

class PokemonTypeWidget extends StatelessWidget {
  const PokemonTypeWidget(this.type, {Key? key}) : super(key: key);
  final PokemonType type;

  @override
  Widget build(BuildContext context) {
    String name = typeToString(type);
    return Column(
      children: [
        Image.asset(
          "assets/types/$name.png",
          height: 60,
        ),
        Text(
          name[0].toUpperCase() + name.substring(1),
          style: const TextStyle(fontSize: 28),
        ),
      ],
    );
  }
}
