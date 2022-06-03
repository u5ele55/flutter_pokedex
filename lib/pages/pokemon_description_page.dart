import 'package:flutter/material.dart';
import 'package:pokedex/models/user_pokemons_sqlite.dart';

import 'package:pokedex/pages/content/pokemon_description_block.dart';
import 'package:pokedex/models/pokemon_data.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

class PokemonDescriptionPage extends StatefulWidget {
  const PokemonDescriptionPage({Key? key, required this.pokemon})
      : super(key: key);
  final Pokemon pokemon;

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

  UserPokemon? userPokemon;

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
                    Expanded(child: Container(), flex: 1),
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
            child: _favoriteButton(),
          ),
        ],
      ),
    );
  }

  _favoriteButton() => FloatingActionButton(
        heroTag: "Favorite btn",
        child: FutureBuilder(
            future: UserPokemonsSQLite().getDBasList(),
            builder: (context, AsyncSnapshot<List<UserPokemon>> snapshot) {
              Widget child;
              print("futureb called : ${userPokemon?.isFavorite}");
              if (snapshot.hasData) {
                userPokemon =
                    _findPokemon(snapshot.data!, widget.pokemon.number);
                child = Icon(
                  userPokemon!.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: userPokemon!.isFavorite ? Colors.red : Colors.black,
                  size: 32,
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                child = const CircularProgressIndicator();
              } else {
                child = const Icon(Icons.error_outline);
              }
              return child;
            }),
        onPressed: () {
          if (userPokemon != null) {
            print("not null");
            _toggleFavorite();
          }
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        highlightElevation: 0,
      );

  UserPokemon _findPokemon(List<UserPokemon> list, int id) {
    for (UserPokemon pokemon in list) {
      if (id == pokemon.id) return pokemon;
    }
    return UserPokemon(id, 1, false);
  }

  void _toggleFavorite() {
    setState(() => userPokemon!.isFavorite = userPokemon!.isFavorite);
    UserPokemonsSQLite().insert(userPokemon!);
  }
}
