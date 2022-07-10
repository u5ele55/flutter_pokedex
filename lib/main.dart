import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/core/constants.dart';

import 'bloc/simple_bloc_observer.dart';
import 'routes.dart';

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
          navigatorKey: AppNavigator.navigatorKey,
          onGenerateRoute: AppNavigator.onGenerateRoute,
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
          //home: const PokemonListPage(),
        );
}
