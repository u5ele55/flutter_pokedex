import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_list/list_bloc.dart';

class PokemonFavoritesFilterButton extends StatelessWidget {
  const PokemonFavoritesFilterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(
      builder: (context, state) => SizedBox(
        height: 64,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((_) {
              return state.searchConfig.isFavorites
                  ? Colors.redAccent
                  : Colors.redAccent.withAlpha(100);
            }),
          ),
          onPressed: () {
            final newConfig = state.searchConfig.copy();
            newConfig.isFavorites = !newConfig.isFavorites;
            context.read<ListBloc>().add(ListQueryChanged(newConfig));
          },
          child: Center(
            child: Text(
              "Favorites",
              style: TextStyle(
                letterSpacing: 1,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color:
                    state.searchConfig.isFavorites ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
