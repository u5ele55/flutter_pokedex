import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_shop/shop_bloc.dart';

import 'content/navigation/navigation_menu.dart';
import 'content/pokemon_shop_view.dart';

class PokemonShopPage extends StatelessWidget {
  const PokemonShopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocProvider(
            create: (_) => ShopBloc()..add(OpenShop()),
            child: const PokemonShopView(),
          ),
          const Positioned(bottom: 32, right: 32, child: PokeballPageMenu()),
        ],
      ),
    );
  }
}
