import 'package:flutter/material.dart';
import 'package:pokedex/constants.dart';
import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/widgets/stroke_text.dart';
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
  final _headerSize = 64.0;
  final _maxPanelHeightPercentage = .8;
  final _minPanelHeightPercentage = .4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        minHeight:
            _minPanelHeightPercentage * MediaQuery.of(context).size.height,
        maxHeight:
            _maxPanelHeightPercentage * MediaQuery.of(context).size.height,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
        panel: Column(
          children: [
            SizedBox(
              height: _headerSize,
            ),
            Text("${widget.pokemon.evolvesFrom}"),
            Text("${widget.pokemon.evolvesTo}"),
            Text("aboba"),
          ],
        ),
        header: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: _headerSize,
          child: Center(
            child: StrokeText(
              widget.pokemon.name,
              style: Theme.of(context).textTheme.headline1?.merge(
                    const TextStyle(
                      shadows: [Shadow(color: Colors.white, blurRadius: 4)],
                      fontSize: 32,
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
                      (1 -
                          _minPanelHeightPercentage -
                          _panelOpenPercentage *
                              (_maxPanelHeightPercentage -
                                  _minPanelHeightPercentage)),
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
