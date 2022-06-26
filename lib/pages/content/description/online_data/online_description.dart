import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_description/description_bloc.dart';
import 'package:pokedex/widgets/circle_loading.dart';

class OnlinePokemonDescription extends StatelessWidget {
  const OnlinePokemonDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: BlocBuilder<DescriptionBloc, DescriptionState>(
          builder: (context, state) {
        switch (state.status) {
          case DescriptionStatus.initial:
            return const CircleLoading();
          case DescriptionStatus.success:
            return Text(
              state.pokemonData[0].description ?? 'No description.',
              style: const TextStyle(fontSize: 28),
            );
          default:
            return const Text("Unable to load description.");
        }
      }),
    );
  }
}
