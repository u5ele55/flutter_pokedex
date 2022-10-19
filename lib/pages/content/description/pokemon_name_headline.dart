import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_description/description_bloc.dart';
import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/widgets/stroke_text.dart';
import 'package:pokedex/core/constants.dart' as constants;

class PokemonNameHeadline extends StatelessWidget {
  const PokemonNameHeadline(this.pokemon, {Key? key}) : super(key: key);
  final Pokemon pokemon;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<DescriptionBloc, DescriptionState>(
          builder: (context, state) {
        final String name;
        if (state.status == DescriptionStatus.success) {
          name = state.currentPokemon!.name!;
        } else {
          name = pokemon.name;
        }
        return StrokeText(
          name,
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
        );
      }),
    );
  }
}
