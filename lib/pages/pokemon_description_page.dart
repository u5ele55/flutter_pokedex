import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_data.dart';

class PokemonDescriptionPage extends StatelessWidget {
  const PokemonDescriptionPage({Key? key, required this.pokemon})
      : super(key: key);
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            pokemon.getImagePath(),
          ),
          Text(pokemon.name),
          Text(pokemon.number.toString()),
        ],
      ),
    );
  }
}
