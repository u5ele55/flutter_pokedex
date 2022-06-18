import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_list/list_bloc.dart';
import 'package:pokedex/models/user_pokemons_sqlite.dart';

import 'package:pokedex/pages/content/pokemon_description_block.dart';
import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/utils.dart';
import 'package:pokedex/widgets/stroke_text.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'content/pokemon_description_favorite_button.dart';

class PokemonDescriptionPage extends StatefulWidget {
  const PokemonDescriptionPage(
      {Key? key, required this.pokemon, this.userPokemon})
      : super(key: key);
  final Pokemon pokemon;
  final UserPokemon? userPokemon;

  @override
  State<PokemonDescriptionPage> createState() => _PokemonDescriptionPageState();
}

class _PokemonDescriptionPageState extends State<PokemonDescriptionPage> {
  double _panelOpenPercentage = 0.0;
  final _maxPanelHeightPercentage = 1.0;
  final _snapPointPercentage = .75;
  final _minPanelHeightPercentage = .4;
  final _parallaxPercentage = .05;
  final _sliderRadius = 18.0;
  final _fabOffset = 12.0;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SlidingUpPanel(
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
              widget.pokemon,
              scrollController: sc,
            ),
            onPanelSlide: (val) => setState(() => _panelOpenPercentage = val),
            body: Column(
              children: [
                Container(
                  height: _sliderRadius +
                      screenSize.height *
                          (1 +
                              _parallaxPercentage -
                              _minPanelHeightPercentage -
                              _panelOpenPercentage *
                                  (_maxPanelHeightPercentage -
                                      _minPanelHeightPercentage)),
                  constraints: BoxConstraints(
                    minHeight: screenSize.height * (1 - _snapPointPercentage),
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      end: Alignment.bottomLeft,
                      begin: Alignment.topRight,
                      colors: [
                        getTypeColor(widget.pokemon.firstType) ?? Colors.white,
                        Colors.white,
                        getTypeColor(widget.pokemon.secondType) ?? Colors.white,
                      ],
                    ),
                  ),
                  child: Flex(direction: Axis.vertical, children: [
                    Expanded(child: Container(), flex: 1),
                    Expanded(child: widget.pokemon.getImageWidget(), flex: 2),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 128,
                            padding: const EdgeInsets.only(left: 12),
                            child: StrokeText(
                              toRomanNumber(widget.pokemon.generation),
                              strokeWidth: 6,
                              strokeColor: Colors.grey[600]!,
                              style: const TextStyle(
                                fontSize: 48,
                                letterSpacing: 6,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 12),
                            height: 128,
                            child: StrokeText(
                              "#${widget.pokemon.number}",
                              strokeColor: Colors.white,
                              strokeWidth: 6,
                              style: TextStyle(
                                color:
                                    (getTypeColor(widget.pokemon.firstType) ??
                                            Colors.grey)
                                        .withAlpha(128),
                                fontSize: 48,
                                letterSpacing: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + _fabOffset,
            left: _fabOffset,
            child: FloatingActionButton.small(
              child: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
              backgroundColor: Colors.white,
              elevation: 6,
              highlightElevation: 4,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + _fabOffset,
            right: _fabOffset,
            child: DescriptionFavoriteButton(
              userPokemon: widget.userPokemon,
            ),
          ),
        ],
      ),
    );
  }
}
