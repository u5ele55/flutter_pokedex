import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/widgets/progress_bar_with_title.dart';
import 'package:pokedex/core/constants.dart' as constants;

class PokemonStatsBlock extends StatelessWidget {
  const PokemonStatsBlock(this.pokemon, {Key? key}) : super(key: key);
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProgressBarWithTitle(
              title: "HP",
              value: pokemon.hp.toString(),
              progress: pokemon.hp / constants.pokemonMaxStats["hp"]!,
              color: Colors.red),
          const SizedBox(height: 8),
          ProgressBarWithTitle(
              title: "Attack",
              value: pokemon.attack.toString(),
              progress: pokemon.attack / constants.pokemonMaxStats["attack"]!,
              color: Colors.blue),
          const SizedBox(height: 8),
          ProgressBarWithTitle(
              title: "Defense",
              value: pokemon.defense.toString(),
              progress: pokemon.defense / constants.pokemonMaxStats["defense"]!,
              color: Colors.green),
          const SizedBox(height: 8),
          ProgressBarWithTitle(
              title: "Speed",
              value: pokemon.speed.toString(),
              progress: pokemon.speed / constants.pokemonMaxStats["speed"]!,
              color: Colors.black),
          const SizedBox(height: 8),
          ProgressBarWithTitle(
              title: "Sp. Attack",
              value: pokemon.specialAttack.toString(),
              progress: pokemon.specialAttack /
                  constants.pokemonMaxStats["sp_attack"]!,
              color: Colors.deepOrange),
          const SizedBox(height: 8),
          ProgressBarWithTitle(
              title: "Sp. Defense",
              value: pokemon.specialDefense.toString(),
              progress: pokemon.specialDefense /
                  constants.pokemonMaxStats["sp_defense"]!,
              color: Colors.deepPurple),
        ],
      ),
    );
  }
}
