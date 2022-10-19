import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pokedex/bloc/pokemon_list/list_bloc.dart';
import 'package:pokedex/core/constants.dart' as constants;
import 'content/pokemon_list_view.dart';
import '../animations/page_loading_animation.dart';

class PokemonListPage extends StatelessWidget {
  const PokemonListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocProvider(
            create: (_) => ListBloc()..add(ListTilesLoaded()),
            child: const PokemonListView(),
          ),
          const PokeballPageLoadingAnimation(delay: constants.loadingDuration),
        ],
      ),
    );
  }
}
