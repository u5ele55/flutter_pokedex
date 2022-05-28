import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundColor: const Color.fromARGB(32, 0, 0, 0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              splashRadius: 24,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SlidingUpPanel(
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
                  minHeight: screenSize.height * (1 - _snapPointPercentage)),
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
    );
  }
}
