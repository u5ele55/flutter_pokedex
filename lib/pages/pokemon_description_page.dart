import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_description/description_bloc.dart';
import 'package:pokedex/bloc/pokemon_favorite/favorite_bloc.dart';
import 'package:pokedex/pages/content/pokemon_description_view.dart';

import 'package:pokedex/models/user_pokemons_sqlite.dart';
import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/routes.dart';

import 'content/description/pokemon_description_favorite_button.dart';

class PokemonDescriptionPage extends StatelessWidget {
  const PokemonDescriptionPage(
      {Key? key, required this.pokemon, this.userPokemon})
      : super(key: key);
  final Pokemon pokemon;
  final UserPokemon? userPokemon;

  final _fabOffset = 12.0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              DescriptionBloc()..add(LoadDescriptionOnlineData(pokemon.number)),
        ),
        BlocProvider(
            create: (_) =>
                FavoriteBloc()..add(ShowFavoriteLabel(pokemon.number))),
      ],
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            PokemonDescriptionView(
              pokemon: pokemon,
              userPokemon: userPokemon,
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + _fabOffset,
              left: _fabOffset,
              child: FloatingActionButton.small(
                child: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => AppNavigator.pop(),
                backgroundColor: Colors.white,
                elevation: 6,
                highlightElevation: 4,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + _fabOffset,
              right: _fabOffset,
              child: DescriptionFavoriteButton(
                userPokemon:
                    userPokemon ?? UserPokemon(pokemon.number, 1, false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
