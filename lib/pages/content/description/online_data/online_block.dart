import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_description/description_bloc.dart';
import 'package:pokedex/pages/content/description/pokemon_description_headline.dart';
import 'package:pokedex/widgets/circle_loading.dart';

import 'data_widgets/data_widgets.dart';

class OnlinePokemonInformationBlock extends StatelessWidget {
  const OnlinePokemonInformationBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DescriptionBloc, DescriptionState>(
        builder: (context, state) {
      switch (state.status) {
        case DescriptionStatus.initial:
          return const CircleLoading();
        case DescriptionStatus.success:
          final currentPokemon = state.currentPokemon!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: Headline("Details")),
                const SizedBox(height: 4),
                PokemonHeightAndWeight(currentPokemon),
                const SizedBox(height: 8),
                PokemonBoolInfo(currentPokemon),
                const SizedBox(height: 8),
                PokemonAbilities(currentPokemon),
                const SizedBox(height: 24),
                const PokemonForms(),
              ],
            ),
          );
        default:
          return const SizedBox.shrink();
      }
    });
  }
}
