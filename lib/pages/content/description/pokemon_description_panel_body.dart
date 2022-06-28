import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/utils.dart';
import 'package:pokedex/widgets/stroke_text.dart';

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
        Container(
          height:
              sliderRadius + screenSize.height * (1 - minPanelHeightPercentage),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              end: Alignment.bottomLeft,
              begin: Alignment.topRight,
              colors: [
                getTypeColor(pokemon.firstType) ?? Colors.white,
                Colors.white,
                getTypeColor(pokemon.secondType) ?? Colors.white,
              ],
            ),
          ),
          child: Flex(direction: Axis.vertical, children: [
            Expanded(child: Container(), flex: 1),
            Expanded(child: pokemon.getImageWidget(), flex: 3),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 128,
                    padding: const EdgeInsets.only(left: 12),
                    child: StrokeText(
                      toRomanNumber(pokemon.generation),
                      strokeWidth: 6,
                      strokeColor: Colors.grey[600]!,
                      style: const TextStyle(
                        fontSize: 48,
                        letterSpacing: 6,
                        color: Colors.white,
                        fontFamily: "Pokemon Solid",
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 12),
                    height: 128,
                    child: StrokeText(
                      "#${pokemon.number}",
                      strokeColor: Colors.white,
                      strokeWidth: 6,
                      style: TextStyle(
                        color: (getTypeColor(pokemon.firstType) ?? Colors.grey)
                            .withAlpha(128),
                        fontSize: 48,
                        letterSpacing: 6,
                        fontFamily: "Pokemon Solid",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
