import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_list/list_bloc.dart';
import 'package:pokedex/pages/content/pokemon_list_search_block.dart';
import 'package:pokedex/widgets/pokemon_list_tile.dart';
import 'package:pokedex/widgets/single_child_sliver.dart';

class PokemonListView extends StatefulWidget {
  const PokemonListView({Key? key}) : super(key: key);

  @override
  State<PokemonListView> createState() => _PokemonListViewState();
}

class _PokemonListViewState extends State<PokemonListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(
      builder: (context, state) {
        if (state.status == ListStatus.initial) {
          return const BottomLoader();
        } else if (state.status == ListStatus.success) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              // SafeArea
              SimpleSliver(
                  child: SizedBox(
                height: MediaQuery.of(context).padding.top + 8,
              )),
              const PokemonListSearchBlock(),
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= state.pokemons.length) {
                      return const BottomLoader();
                    }
                    var pokemonData = state.pokemons[index].pokemonData;
                    var userData = state.pokemons[index].userData;
                    return PokemonListTile(
                      pokemon: pokemonData,
                      userPokemon: userData,
                      preferPNG: true,
                    );
                  },
                  // Is this really helped to boost performance??
                  //addAutomaticKeepAlives: false,
                  //addSemanticIndexes: false,
                  //addRepaintBoundaries: false,
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
              ),
            ],
          );
        } else {
          return const Text("no");
        }
      },
    );
  }

  void _onScroll() {
    if (_isBottom) context.read<ListBloc>().add(ListTilesLoaded());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

class BottomLoader extends StatelessWidget {
  const BottomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 1.5),
      ),
    );
  }
}
