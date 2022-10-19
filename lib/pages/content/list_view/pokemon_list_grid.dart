import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_list/list_bloc.dart';
import 'package:pokedex/widgets/circle_loading.dart';
import 'package:pokedex/widgets/pokemon_list_tile.dart';
import 'package:pokedex/widgets/single_child_sliver.dart';

class PokemonListGrid extends StatelessWidget {
  const PokemonListGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(builder: (context, state) {
      if (state.status == ListStatus.initial) {
        return SimpleSliver(child: const CircleLoading());
      } else if (state.status == ListStatus.success) {
        return SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= state.pokemons.length) {
                return const CircleLoading();
              }
              var pokemonData = state.pokemons[index].pokemonData;
              var userData = state.pokemons[index].userData;
              return PokemonListTile(
                pokemon: pokemonData,
                userPokemon: userData,
                preferPNG: true,
                entryOfList: true,
              );
            },
            childCount: state.hasReachedMax
                ? state.pokemons.length
                : state.pokemons.length + state.pokemons.length % 2 + 2,
          ),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
        );
      } else {
        return SimpleSliver(child: const Text("no"));
      }
    });
  }
}
