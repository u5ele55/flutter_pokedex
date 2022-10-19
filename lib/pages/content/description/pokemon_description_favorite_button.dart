import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_favorite/favorite_bloc.dart';
import 'package:pokedex/models/user_pokemons_sqlite.dart';

class DescriptionFavoriteButton extends StatelessWidget {
  const DescriptionFavoriteButton({Key? key, required this.userPokemon})
      : super(key: key);
  final UserPokemon userPokemon;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) => FloatingActionButton(
        heroTag: "Favorite btn",
        child: Icon(
          (state.isFavorite ?? false) ? Icons.favorite : Icons.favorite_border,
          color: (state.isFavorite ?? false) ? Colors.red : Colors.black,
          size: 32,
        ),
        onPressed: () {
          context.read<FavoriteBloc>().add(ToggleFavorite(userPokemon.id));
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        highlightElevation: 0,
      ),
    );
  }
}
