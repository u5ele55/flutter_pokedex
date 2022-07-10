import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_list/list_bloc.dart';
import 'package:pokedex/core/constants.dart' as constants;
import 'package:pokedex/decorators/pokemon_tile_ornament.dart';
import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/models/pokemon_data_handler.dart';
import 'package:pokedex/models/user_pokemons_sqlite.dart';
import 'package:pokedex/widgets/stroke_text.dart';

import '../routes.dart';

class PokemonListTile extends StatelessWidget {
  PokemonListTile({
    Key? key,
    required this.pokemon,
    this.userPokemon,
    this.displayName = true,
    this.preferPNG = false,
    this.entryOfList = false,
  }) : super(key: key);

  final Pokemon pokemon;
  final UserPokemon? userPokemon;
  final bool displayName;
  final bool preferPNG;
  final bool entryOfList;

  final GlobalKey _cardKey = GlobalKey();

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
        onTap: () => _onTap(context),
        child: Stack(
          children: [
            // ORNAMENT
            CustomPaint(
              child: Padding(
                padding: preferPNG
                    ? const EdgeInsets.all(0)
                    : const EdgeInsets.all(12),
                child: Center(
                  child: Image.asset(
                    pokemon.getImagePath(),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              foregroundPainter: getTypeColor(pokemon.secondType) == null
                  ? null
                  : CurvedPainter(getTypeColor(pokemon.secondType)!,
                      isSecondType: true),
              painter: getTypeColor(pokemon.firstType) == null
                  ? null
                  : CurvedPainter(getTypeColor(pokemon.firstType)!),
            ),
            // NAME
            if (displayName)
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: StrokeText(
                    pokemon.name,
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        ?.merge(const TextStyle(
                          shadows: [Shadow(color: Colors.white, blurRadius: 4)],
                          fontSize: 20,
                          fontFamily: "Pokemon Solid",
                        )),
                    strokeColor: constants.bluePokemonColor,
                    strokeWidth: 4,
                  ),
                ),
              ),
            // ID
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: (userPokemon?.isFavorite ?? false)
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (userPokemon?.isFavorite ?? false)
                      const Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.favorite_border,
                          size: 34,
                        ),
                      ),
                    StrokeText(
                      "#${pokemon.number}",
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w100,
                        shadows: [Shadow(color: Colors.white, blurRadius: 22)],
                        fontStyle: FontStyle.italic,
                        fontFamily: "Pokemon Solid",
                      ),
                      strokeWidth: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final result = await AppNavigator.push(
      Routes.description,
      PokemonFullData(
        pokemonData: pokemon,
        userData: userPokemon,
      ),
    );
    if (entryOfList) {
      context.read<ListBloc>().add(UserPokemonDataChanged(pokemon.number));
    }
  }
}
