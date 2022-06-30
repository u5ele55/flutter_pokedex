import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_json_data.dart';

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
              Center(child: _headline("Abilities", 40)),
              if (normal.isNotEmpty) _headline("Normal"),
              for (String ability in normal)
                Text(ability, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 8),
              if (hidden.isNotEmpty) _headline("Hidden"),
              for (String ability in hidden)
                Text(ability, style: const TextStyle(fontSize: 28)),
            ],
          )
        : const SizedBox.shrink();
  }

  _headline(String text, [double fontSize = 32]) => Text(text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ));
}
