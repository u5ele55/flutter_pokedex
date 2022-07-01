import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_json_data.dart';

class OnlinePokemonCard extends StatelessWidget {
  const OnlinePokemonCard(this.pokemon, {Key? key}) : super(key: key);
  final PokemonOnlineData pokemon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
            image: NetworkImage(pokemon.sprite!), fit: BoxFit.cover),
        border: Border.all(),
      ),
      child: Card(
          color: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Text('Heyyyy')),
    );
  }
}
