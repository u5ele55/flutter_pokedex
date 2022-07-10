import 'package:flutter/material.dart';
import 'package:pokedex/routes.dart';

part 'menu_entry.dart';

class PokeballPageMenu extends StatelessWidget {
  const PokeballPageMenu({Key? key}) : super(key: key);

  static const Map<Routes, String> routes = {
    Routes.list: "List",
    Routes.shop: "Shop",
  };

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Routes>(
      child: Container(
        color: Colors.red,
        height: 80,
        width: 80,
      ),
      onSelected: (Routes route) {
        if (route != AppNavigator.currentRoute) {
          AppNavigator.push(route);
        }
      },
      itemBuilder: (context) {
        return [
          for (Routes route in routes.keys) NavigationMenuEntry(route),
        ];
      },
      offset: Offset(0, -100),
    );
  }

  PopupMenuItem<T> a<T>() => PopupMenuItem<T>(
        child: Text('a'),
      );
}
