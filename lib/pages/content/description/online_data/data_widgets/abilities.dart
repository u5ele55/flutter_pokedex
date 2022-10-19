import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_json_data.dart';

import 'details_headline.dart';

class PokemonAbilities extends StatelessWidget {
  const PokemonAbilities(this.currentPokemon, {Key? key}) : super(key: key);
  final PokemonOnlineData currentPokemon;
  @override
  Widget build(BuildContext context) {
    List<String> normal = currentPokemon.abilities?.normal ?? [],
        hidden = currentPokemon.abilities?.hidden ?? [];
    bool exists = normal.isNotEmpty | hidden.isNotEmpty;
    return exists
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: DetailsHeadline("Abilities", fontSize: 40)),
              const SizedBox(height: 8),
              if (normal.isNotEmpty) const DetailsHeadline("Normal"),
              for (String ability in normal)
                Text(ability, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 8),
              if (hidden.isNotEmpty) const DetailsHeadline("Hidden"),
              for (String ability in hidden)
                Text(ability, style: const TextStyle(fontSize: 28)),
            ],
          )
        : const SizedBox.shrink();
  }
}
