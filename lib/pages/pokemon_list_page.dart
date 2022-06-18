import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_list/list_bloc.dart';
import 'package:pokedex/constants.dart' as constants;
import 'package:pokedex/pages/content/pokemon_list_view.dart';
import 'package:pokedex/widgets/page_loading_animation.dart';

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
          const PokeballPageLoadingAnimation(
              duration: constants.loadingDuration),
        ],
      ),
    );
  }
}
