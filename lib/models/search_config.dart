import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_data.dart';

class SearchConfig {
  TextEditingController searchFieldController;
  Map<PokemonType, bool> types;
  bool isFavorites;

  SearchConfig()
      : searchFieldController = TextEditingController(),
        types = {for (var item in PokemonType.values) item: true},
        isFavorites = false;

  SearchConfig copy() {
    SearchConfig newConfig = SearchConfig();
    newConfig
      ..isFavorites = isFavorites
      ..searchFieldController = searchFieldController;
    types.forEach((key, value) => newConfig.types[key] = value);

    return newConfig;
  }

  @override
  String toString() {
    return "<SearchConfig: \"${searchFieldController.text}\" | fav: $isFavorites | types: ${types.values.where((element) => element).length}>";
  }
}
