import 'package:flutter/material.dart';
import 'package:pokedex/pages/pokemon_list_page.dart';
import 'package:pokedex/pages/unknown_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const PokemonListPage(),
    );
  }
}
