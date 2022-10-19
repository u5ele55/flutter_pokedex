import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_json_data.dart';

class PokemonHeightAndWeight extends StatelessWidget {
  const PokemonHeightAndWeight(this.currentPokemon, {Key? key})
      : super(key: key);
  final PokemonOnlineData currentPokemon;
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: _doubleRowText(
              "Height",
              currentPokemon.height ?? "unknown",
            ),
            flex: 2,
          ),
          const Expanded(
            child: VerticalDivider(thickness: 4),
            flex: 1,
          ),
          Expanded(
            child: _doubleRowText(
              "Weight",
              currentPokemon.weight ?? "unknown",
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  _doubleRowText(String first, String second) {
    const TextStyle _style = TextStyle(
      fontSize: 32,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(first, style: _style),
        Text(second, style: _style),
      ],
    );
  }
}
