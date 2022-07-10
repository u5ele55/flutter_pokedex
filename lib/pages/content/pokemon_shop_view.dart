import 'package:flutter/material.dart';
import 'package:pokedex/widgets/single_child_sliver.dart';

import 'shop/shop.dart';

class PokemonShopView extends StatelessWidget {
  const PokemonShopView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // SafeArea
        SimpleSliver(
          child: SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
        ),
        SimpleSliver(
          child: const ShopHeader(),
        ),
        const PokemonShopList(),
      ],
    );
  }
}
