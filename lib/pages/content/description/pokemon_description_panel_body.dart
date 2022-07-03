import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_description/description_bloc.dart';
import 'package:pokedex/models/pokemon_data.dart';

import 'pokemon_description_panel_body_view.dart';

class PokemonDescriptionPanelBody extends StatelessWidget {
  const PokemonDescriptionPanelBody(this.pokemon,
      {Key? key,
      required this.minPanelHeightPercentage,
      required this.sliderRadius})
      : super(key: key);

  final Pokemon pokemon;

  final double minPanelHeightPercentage;
  final double sliderRadius;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        BlocBuilder<DescriptionBloc, DescriptionState>(
            builder: (context, state) {
          List<PokemonType?> types;
          List<Color> gradient;
          if (state.currentPokemon?.types != null) {
            types = state.currentPokemon!.types!
                .map((type) => typeFromString(type))
                .toList();
            types.add(null);
            gradient = [
              getTypeColor(types[0]) ?? Colors.white,
              Colors.white,
              getTypeColor(types[1]) ?? Colors.white
            ];
          } else {
            gradient = [
              getTypeColor(pokemon.firstType) ?? Colors.white,
              Colors.white,
              getTypeColor(pokemon.secondType) ?? Colors.white,
            ];
          }

          return Container(
            height: sliderRadius +
                screenSize.height * (1 - minPanelHeightPercentage),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                end: Alignment.bottomLeft,
                begin: Alignment.topRight,
                colors: gradient,
              ),
            ),
            child: DescriptionPanelBodyView(pokemon),
          );
        }),
      ],
    );
  }
}
