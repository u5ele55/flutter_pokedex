import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/models/user_pokemons_sqlite.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'description/pokemon_description_block.dart';
import 'description/pokemon_description_panel_body.dart';

class PokemonDescriptionView extends StatelessWidget {
  const PokemonDescriptionView(
      {Key? key, required this.pokemon, this.userPokemon})
      : super(key: key);
  final Pokemon pokemon;
  final UserPokemon? userPokemon;

  final _maxPanelHeightPercentage = 1.0;
  final _snapPointPercentage = .75;
  final _minPanelHeightPercentage = .4;
  final _parallaxPercentage = .1;
  final _sliderRadius = 18.0;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SlidingUpPanel(
      parallaxEnabled: true,
      parallaxOffset: _parallaxPercentage,
      snapPoint: _snapPointPercentage,
      minHeight: _minPanelHeightPercentage * screenSize.height,
      maxHeight: _maxPanelHeightPercentage * screenSize.height,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(_sliderRadius),
        topRight: Radius.circular(_sliderRadius),
      ),
      panelBuilder: (sc) => PokemonDescriptionBlock(
        pokemon,
        scrollController: sc,
      ),
      body: PokemonDescriptionPanelBody(
        pokemon,
        sliderRadius: _sliderRadius,
        minPanelHeightPercentage: _minPanelHeightPercentage,
      ),
    );
  }
}
