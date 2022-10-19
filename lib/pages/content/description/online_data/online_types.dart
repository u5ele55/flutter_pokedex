import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_description/description_bloc.dart';
import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/pages/content/description/online_data/data_widgets/type_widget.dart';

class PokemonTypesBlock extends StatelessWidget {
  const PokemonTypesBlock(this.pokemon, {Key? key}) : super(key: key);
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DescriptionBloc, DescriptionState>(
      builder: (context, state) {
        List<Widget> typeWidgets;
        if (state.status == DescriptionStatus.success) {
          typeWidgets = state.currentPokemon!.types!
              .map((e) => PokemonTypeWidget(typeFromString(e)!))
              .toList();
        } else {
          typeWidgets = [pokemon.firstType, pokemon.secondType]
              .where((element) => element != null)
              .map((e) => PokemonTypeWidget(e!))
              .toList();
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: typeWidgets,
        );
      },
    );
  }
}
