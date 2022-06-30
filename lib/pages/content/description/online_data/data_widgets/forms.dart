import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_description/description_bloc.dart';
import 'package:pokedex/models/pokemon_json_data.dart';

class PokemonForms extends StatelessWidget {
  const PokemonForms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DescriptionBloc, DescriptionState>(
      builder: (context, state) {
        if (state.status != DescriptionStatus.success ||
            state.pokemonData.length == 1) {
          return const SizedBox.shrink();
        }
        return SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              // TODO : place blocks of pokemon's forms here, make bloc event to change currentPokemon
              for (PokemonOnlineData po in state.pokemonData) ...[
                Container(
                  width: 80,
                  height: 80,
                  color: Colors.amber,
                ),
                SizedBox(width: 4)
              ]
            ],
          ),
        );
      },
    );
  }
}
