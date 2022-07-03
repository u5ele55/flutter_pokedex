import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_json_data.dart';
import 'package:pokedex/pages/content/description/online_data/data_widgets/tag_widget.dart';

import 'details_headline.dart';

class PokemonBoolInfo extends StatelessWidget {
  const PokemonBoolInfo(this.currentPokemon, {Key? key}) : super(key: key);
  final PokemonOnlineData currentPokemon;

  @override
  Widget build(BuildContext context) {
    final p = currentPokemon;
    Map<String, bool?> bools = {
      "Starter": p.starter,
      "Mega": p.mega,
      "Legendary": p.legendary,
      "Mythical": p.mythical,
      "Ultra Beast": p.ultraBeast,
    };

    return bools.values.any((e) => e ?? false)
        ? Column(
            children: [
              const DetailsHeadline("Tags", fontSize: 40),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (String key in bools.keys)
                    if (bools[key] ?? false) PokemonTagWidget(key),
                ],
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
