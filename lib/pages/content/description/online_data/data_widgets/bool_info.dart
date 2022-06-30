import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pokedex/models/pokemon_json_data.dart';

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
        ? Row(children: [
            for (String key in bools.keys)
              if (bools[key] ?? false) _temp(key),
          ])
        : const SizedBox.shrink();
  }

  _temp(String text) {
    return Column(
      children: [
        Container(
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.amber),
          width: 48,
          height: 48,
        ),
        Text(text, style: TextStyle(fontSize: 24))
      ],
    );
  }
}
