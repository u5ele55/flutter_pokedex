import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_data_handler.dart';
import 'package:pokedex/pages/pokemon_description_page.dart';
import 'package:pokedex/pages/pokemon_list_page.dart';
import 'core/page_transition.dart';

enum Routes { list, description, shop }

class _Paths {
  static const String list = '/';
  static const String description = '/description';
  static const String shop = '/shop';

  static const Map<Routes, String> _pathMap = {
    Routes.list: list,
    Routes.description: description,
    Routes.shop: shop,
  };

  static String of(Routes route) => _pathMap[route] ?? list;
}

class AppNavigator {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case _Paths.description:
        final pfd = settings.arguments as PokemonFullData;
        return PageTransitionRoute(
          page: PokemonDescriptionPage(
            pokemon: pfd.pokemonData,
            userPokemon: pfd.userData,
          ),
        );
      case _Paths.list:
      default:
        return PageTransitionRoute(page: const PokemonListPage());
    }
  }

  static Future? push<T>(Routes route, [T? arguments]) =>
      state?.pushNamed(_Paths.of(route), arguments: arguments);

  // TODO: it gives null no matter what.
  static Routes? get currentRoute {
    String? curPath;
    AppNavigator.state?.popUntil((route) {
      curPath = route.settings.name;
      return true;
    });
    for (Routes route in Routes.values) {
      if (_Paths.of(route) == curPath) return route;
    }
    return null;
  }

  static Future? replaceWith<T>(Routes route, [T? arguments]) =>
      state?.pushReplacementNamed(_Paths.of(route), arguments: arguments);

  static void pop() => state?.pop();

  static NavigatorState? get state => navigatorKey.currentState;
}
