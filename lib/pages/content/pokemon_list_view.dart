import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pokedex/bloc/pokemon_list/list_bloc.dart';
import 'package:pokedex/widgets/single_child_sliver.dart';

import 'list_search/pokemon_list_search_block.dart';
import 'list_view/made_with_love.dart';
import 'list_view/pokemon_list_grid.dart';

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
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ListBloc>().add(ListRefresh());
      },
      child: Scrollbar(
        thickness: 16,
        hoverThickness: 24,
        radius: const Radius.circular(4),
        controller: _scrollController,
        interactive: true,
        child: Padding(
          padding: const EdgeInsets.only(right: 6, left: 6),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // SafeArea
              SimpleSliver(
                child: SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
              ),
              SimpleSliver(
                child: const MadeWithLoveLabel(),
              ),
              const PokemonListSearchBlock(),
              const PokemonListGrid(),
            ],
          ),
        ),
      ),
    );
  }

  void _onScroll() {
    if (_isBottom) context.read<ListBloc>().add(ListTilesLoaded());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 36);
  }
}
