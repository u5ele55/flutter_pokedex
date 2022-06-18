import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_list/list_bloc.dart';
import 'package:pokedex/models/pokemon_data_handler.dart';
import 'package:pokedex/models/user_pokemons_sqlite.dart';

class DescriptionFavoriteButton extends StatefulWidget {
  const DescriptionFavoriteButton({Key? key, this.userPokemon})
      : super(key: key);
  final UserPokemon? userPokemon;

  @override
  State<DescriptionFavoriteButton> createState() =>
      _DescriptionFavoriteButtonState();
}

class _DescriptionFavoriteButtonState extends State<DescriptionFavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "Favorite btn",
      child: Icon(
        (widget.userPokemon?.isFavorite ?? false)
            ? Icons.favorite
            : Icons.favorite_border,
        color: (widget.userPokemon?.isFavorite ?? false)
            ? Colors.red
            : Colors.black,
        size: 32,
      ),
      onPressed: () {
        if (widget.userPokemon != null) {
          setState(() =>
              widget.userPokemon!.isFavorite = !widget.userPokemon!.isFavorite);
          PokemonDataHandler().changeUserData(widget.userPokemon!);
        }
      },
      backgroundColor: Colors.transparent,
      elevation: 0,
      highlightElevation: 0,
    );
  }
}
