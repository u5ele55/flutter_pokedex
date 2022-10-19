import 'package:flutter/material.dart';

import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/pages/content/description/pokemon_description_evolution_graph.dart';
import 'package:pokedex/pages/content/description/pokemon_description_headline.dart';
import 'package:pokedex/pages/content/description/pokemon_description_stats.dart';

import 'online_data/online_data.dart';
import 'pokemon_name_headline.dart';

class PokemonDescriptionBlock extends StatelessWidget {
  const PokemonDescriptionBlock(this.pokemon, {Key? key, this.scrollController})
      : super(key: key);

  final Pokemon pokemon;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      //shrinkWrap: true,
      children: [
        //SizedBox(height: MediaQuery.of(context).padding.top),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            children: [
              PokemonNameHeadline(pokemon),
              OnlinePokemonDescription(pokemon.number),
              const SizedBox(height: 4),
              PokemonTypesBlock(pokemon),
              const SizedBox(height: 16),
              const Headline("Stats"),
              PokemonStatsBlock(pokemon),
              const SizedBox(height: 16),
              const Headline("Evolution chart"),
              const SizedBox(height: 16),
            ],
          ),
        ),
        PokemonEvolutionGraph(pokemon),
        const SizedBox(height: 16),
        const OnlinePokemonInformationBlock(),
        const SizedBox(height: 16),
      ],
    );
  }
}
