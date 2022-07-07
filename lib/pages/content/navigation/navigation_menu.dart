import 'package:dropdown_button2/dropdown_button2.dart'; // TODO: delete from pubspec
import 'package:flutter/material.dart';
import 'package:pokedex/pages/pokemon_catch_page.dart';

class PokeballPageMenu extends StatelessWidget {
  const PokeballPageMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      child: Container(
        color: Colors.red,
        height: 80,
        width: 80,
      ),
      onSelected: (int a) {
        print(ModalRoute.of(context)?.settings.name);
        if (a == 1) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PokemonCatchPage()));
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: Text("Aboba!!!!"),
            value: 1,
          ),
          PopupMenuItem(
            child: Text("Aboba"),
            value: 2,
          ),
        ];
      },
      offset: Offset(0, -100),
    );
  }
}
