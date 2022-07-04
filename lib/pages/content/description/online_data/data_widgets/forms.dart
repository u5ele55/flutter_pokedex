import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_description/description_bloc.dart';
import 'package:pokedex/models/pokemon_json_data.dart';
import 'package:pokedex/pages/content/description/online_data/data_widgets/details_headline.dart';
import 'package:pokedex/pages/content/description/online_data/data_widgets/online_pokemon_card.dart';

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
          width: double.infinity,
          child: Column(
            children: [
              const DetailsHeadline("Forms", fontSize: 40),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    for (PokemonOnlineData pokemon in state.pokemonData)
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: OnlinePokemonCard(pokemon),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
