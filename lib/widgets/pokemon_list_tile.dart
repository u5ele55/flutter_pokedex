import 'package:flutter/material.dart';
import 'package:pokedex/constants.dart' as constants;
import 'package:pokedex/decorators/pokemon_tile_ornament.dart';
import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/models/user_pokemons_sqlite.dart';
import 'package:pokedex/pages/pokemon_description_page.dart';
import 'package:pokedex/widgets/stroke_text.dart';

class PokemonListTile extends StatefulWidget {
  const PokemonListTile(
      {Key? key,
      required this.pokemon,
      this.userPokemon,
      this.displayName = true,
      this.preferPNG = false,
      this.startOpacity = 0.7})
      : super(key: key);

  final Pokemon pokemon;
  final UserPokemon? userPokemon;
  final bool displayName;
  final bool preferPNG;
  final double startOpacity;

  @override
  State<PokemonListTile> createState() => _PokemonListTileState();
}

class _PokemonListTileState extends State<PokemonListTile> {
  late double _opacity = widget.startOpacity;
  final GlobalKey _cardKey = GlobalKey();

  @override
  void initState() {
    debugPrint("Init ${widget.pokemon.number}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      key: _cardKey,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      child: InkWell(
        onTap: () => {
          FocusScope.of(context).unfocus(),
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PokemonDescriptionPage(
                pokemon: widget.pokemon,
                userPokemon: widget.userPokemon,
              ),
            ),
          )
        },
        //child: Listener(
        //onPointerDown: (_) => {setState(() => _opacity = 1)},
        //onPointerUp: (_) => {setState(() => _opacity = widget.startOpacity)},
        child: Stack(
          children: [
            /*AnimatedOpacity(
                curve: Curves.easeIn,
                opacity: _opacity,
                duration: const Duration(milliseconds: 100),
                child: */
            CustomPaint(
              child: Padding(
                padding: widget.preferPNG
                    ? const EdgeInsets.all(0)
                    : const EdgeInsets.all(12),
                child: Center(
                  child: widget.pokemon
                      .getImageWidget(preferPNG: widget.preferPNG),
                ),
              ),
              foregroundPainter: getTypeColor(widget.pokemon.secondType) == null
                  ? null
                  : CurvedPainter(getTypeColor(widget.pokemon.secondType)!,
                      isSecondType: true),
              painter: getTypeColor(widget.pokemon.firstType) == null
                  ? null
                  : CurvedPainter(getTypeColor(widget.pokemon.firstType)!),
            ),
            //),
            if (widget.displayName)
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: StrokeText(
                    widget.pokemon.name,
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        ?.merge(const TextStyle(
                          shadows: [Shadow(color: Colors.white, blurRadius: 4)],
                          fontSize: 20,
                        )),
                    strokeColor: constants.bluePokemonColor,
                    strokeWidth: 4,
                  ),
                ),
              ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.userPokemon?.isFavorite ?? false)
                      const Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.favorite_border,
                          size: 34,
                        ),
                      ),
                    StrokeText(
                      "#${widget.pokemon.number}",
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w100,
                        shadows: [Shadow(color: Colors.white, blurRadius: 22)],
                        fontStyle: FontStyle.italic,
                      ),
                      strokeWidth: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        //),
      ),
    );
  }
}
