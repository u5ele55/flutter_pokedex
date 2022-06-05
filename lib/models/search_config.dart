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
}
