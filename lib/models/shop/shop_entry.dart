import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:pokedex/models/pokemon_data_handler.dart';
import 'package:pokedex/models/search_config.dart';

abstract class ShopEntry<T> extends Equatable {
  final String name;
  final int cost;
  final String? description;

  const ShopEntry({required this.name, required this.cost, this.description});

  Future<T> get item;

  @override
  List<Object?> get props => [name, cost];
}

abstract class ShopPokeball extends ShopEntry<PokemonFullData> {
  const ShopPokeball(
      {required String name, required int cost, String? description})
      : super(
          name: name,
          cost: cost,
          description: description,
        );
}

class ShopTestPokeball extends ShopPokeball {
  ShopTestPokeball(
      {required String name, required int cost, String? description})
      : super(name: name, cost: cost, description: description);

  PokemonFullData? _item;
  @override
  Future<PokemonFullData> get item async {
    if (_item != null) return _item!;
    final searchConfig = SearchConfig()..generations = {1: true};
    final data = await PokemonDataHandler().filterPokemonList(searchConfig);
    return [data[0], data[1]][Random().nextInt(2)];
  }

  @override
  List<Object?> get props => [name, cost, _item];
}
