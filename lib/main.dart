import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/constants.dart';
import 'package:pokedex/pages/pokemon_list_page.dart';

import 'bloc/simple_bloc_observer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  BlocOverrides.runZoned(
    () => runApp(MyApp()),
    blocObserver: SimpleBlocObserver(),
  );
}

class MyApp extends MaterialApp {
  MyApp({Key? key})
      : super(
          key: key,
          title: 'Pokedex',
          theme: ThemeData(
            primarySwatch: Colors.grey,
            fontFamily: "Merchant Copy",
            textTheme: const TextTheme(
              headline1: TextStyle(
                fontWeight: FontWeight.w400,
                letterSpacing: 3,
                color: yellowPokemonColor,
              ),
            ),
          ),
          home: const PokemonListPage(),
        );
}
