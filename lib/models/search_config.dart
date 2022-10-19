import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/core/constants.dart' as constants;

class SearchConfig {
  TextEditingController searchFieldController;
  Map<PokemonType, bool> types;
  Map<int, bool> generations;
  bool isFavorites;

  SearchConfig()
      : searchFieldController = TextEditingController(),
        types = {for (var item in PokemonType.values) item: true},
        generations = {
          for (int item = 0; item <= constants.maxPokemonGeneration; item++)
            item: true
        },
        isFavorites = false;

  SearchConfig copy() {
    SearchConfig newConfig = SearchConfig();
    newConfig
      ..isFavorites = isFavorites
      ..searchFieldController = searchFieldController;
    types.forEach((key, value) => newConfig.types[key] = value);
    generations.forEach((key, value) => newConfig.generations[key] = value);

    return newConfig;
  }

  @override
  String toString() {
    return "<SearchConfig: \"${searchFieldController.text}\" | fav: $isFavorites | types: ${types.values.where((element) => element).length}>";
  }
}
