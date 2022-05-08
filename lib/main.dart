import 'package:flutter/material.dart';
import 'package:pokedex/pages/pokemon_list_page.dart';

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
        fontFamily: "Pokemon Solid",
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontWeight: FontWeight.w400,
            letterSpacing: 3,
            color: Color.fromRGBO(255, 203, 5, 1),
          ),
        ),
        highlightColor: const Color.fromRGBO(42, 117, 187, 1),
      ),
      home: const PokemonListPage(),
    );
  }
}
