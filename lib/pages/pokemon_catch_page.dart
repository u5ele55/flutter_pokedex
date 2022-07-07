import 'package:flutter/material.dart';

import 'content/navigation/navigation_menu.dart';

class PokemonCatchPage extends StatelessWidget {
  const PokemonCatchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Text(
              "Catch 'em!",
              style: TextStyle(fontSize: 36),
            ),
          ),
          const Positioned(bottom: 32, right: 32, child: PokeballPageMenu()),
        ],
      ),
    );
  }
}
