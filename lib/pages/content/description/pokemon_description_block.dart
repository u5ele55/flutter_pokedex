import 'package:flutter/material.dart';

import 'package:pokedex/constants.dart' as constants;
import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/pages/content/description/pokemon_description_evolution_graph.dart';
import 'package:pokedex/pages/content/description/pokemon_description_stats.dart';
import 'package:pokedex/widgets/stroke_text.dart';

import 'online_data/online_data.dart';

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
        SizedBox(height: MediaQuery.of(context).padding.top),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: StrokeText(
              pokemon.name,
              style: Theme.of(context).textTheme.headline1?.merge(
                    const TextStyle(
                      shadows: [Shadow(color: Colors.white, blurRadius: 4)],
                      fontSize: 32,
                      fontFamily: "Pokemon Solid",
                    ),
                  ),
              strokeColor: constants.bluePokemonColor,
              strokeWidth: 4,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            children: [
              const OnlinePokemonDescription(),
              const SizedBox(height: 4),
              _headline("Stats"),
              PokemonStatsBlock(pokemon),
              const SizedBox(height: 16),
              _headline("Evolution chart"),
              const SizedBox(height: 16),
            ],
          ),
        ),
        PokemonEvolutionGraph(pokemon),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            children: [],
          ),
        ),
      ],
    );
  }

  StrokeText _headline(String text, [double fontSize = 32]) => StrokeText(
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
