import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pokedex/constants.dart';
import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/widgets/stroke_text.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PokemonDescriptionPage extends StatefulWidget {
  PokemonDescriptionPage({Key? key, required this.pokemon}) : super(key: key);
  final Pokemon pokemon;

  @override
  State<PokemonDescriptionPage> createState() => _PokemonDescriptionPageState();
}

class _PokemonDescriptionPageState extends State<PokemonDescriptionPage> {
  double _panelOpenPercentage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: MediaQuery.of(context).size.height / 2,
        maxHeight: .75 * MediaQuery.of(context).size.height,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
        panel: Column(
          children: [
            SizedBox(
              height: 54,
            ),
            Text("aboba"),
            Text("aboba"),
            Text("aboba"),
          ],
        ),
        header: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 54,
          child: Center(
            child: StrokeText(
              widget.pokemon.name,
              style: Theme.of(context).textTheme.headline1?.merge(
                    const TextStyle(
                      shadows: [Shadow(color: Colors.white, blurRadius: 4)],
                      fontSize: 20,
                    ),
                  ),
              strokeColor: bluePokemonColor,
              strokeWidth: 4,
            ),
          ),
        ),
        onPanelSlide: (val) => setState(() => _panelOpenPercentage = val),
        body: Column(
          children: [
            Container(
              height: 12 +
                  MediaQuery.of(context).size.height *
                      (.5 - _panelOpenPercentage / 4),
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
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Expanded(
                    flex: 4,
                    child: Image.asset(
                      widget.pokemon.getImagePath(),
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
