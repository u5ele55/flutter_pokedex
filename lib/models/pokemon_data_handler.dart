import 'dart:async';

import 'package:pokedex/constants.dart' as constants;
import 'package:pokedex/models/pokemon_json_data.dart';
import 'package:pokedex/services/api_pokedex_service.dart';

import 'csv_handler.dart';
import 'pokemon_data.dart';
import 'user_pokemons_sqlite.dart';
import 'search_config.dart';

class PokemonFullData {
  final Pokemon pokemonData;
  UserPokemon? userData;

  PokemonFullData({required this.pokemonData, this.userData});
  @override
  String toString() {
    return "<PFD : ${pokemonData.number}>";
  }
}

class PokemonDataHandler {
  // {"Pokemon": Pokemon(...), "UserPokemon": UserPokemon(...)}
  static List<PokemonFullData>? _savedPokemonData;

  Future<List<PokemonFullData>> get pokemonData async {
    if (_savedPokemonData == null) {
      final List<List> csv = await filterByUniqueId(
          CSVHandler.readCsvFile(constants.pathToPokemonCsv));
      final List<UserPokemon> sql = await UserPokemonsSQLite().getDBasList();
      _savedPokemonData = [];
      for (int index = 0; index < csv.length; index++) {
        _savedPokemonData!
            .add(PokemonFullData(pokemonData: Pokemon.fromList(csv[index])));
      }
      for (UserPokemon up in sql) {
        _savedPokemonData![up.id - 1].userData = up;
      }
    }
    return _savedPokemonData!;
  }

  void changeUserData(UserPokemon data, {bool? isFavorite, int? catched}) {
    _savedPokemonData![data.id - 1].userData = data.copyWith(
      isFavorite: isFavorite,
      catched: catched,
    );
    UserPokemonsSQLite().insert(data);
  }

  Future<List<List<dynamic>>> filterByUniqueId(
      Future<List<List<dynamic>>> fields) async {
    List<List<dynamic>> filtered = [];

    List<List<dynamic>> readyFields = await fields;
    List<bool> was = List.filled(readyFields.length, false);
    for (int i = 1; i < readyFields.length; i++) {
      if (!was[readyFields[i][0]]) {
        filtered.add(readyFields[i]);
        was[readyFields[i][0]] = true;
      }
    }
    return filtered;
  }

  Future<List<PokemonFullData>> filterPokemonList(
      SearchConfig searchConfig) async {
    String query = searchConfig.searchFieldController.text;
    var loadedData = await pokemonData;
    query = query.toLowerCase();

    List<PokemonFullData> res = [];
    // If query is just an integer - return pokemon with IDs, that contain this number.
    if (int.tryParse(query) != null) {
      for (PokemonFullData pokemon in loadedData) {
        if (pokemon.pokemonData.number.toString().contains(query)) {
          res.add(pokemon);
        }
      }
    } else {
      // Query is pure string
      for (PokemonFullData pokemon in loadedData) {
        if (pokemon.pokemonData.name.toLowerCase().contains(query)) {
          res.add(pokemon);
        }
      }
    }

    // Filtered by name and ids so far
    // Filtering by types:
    List<PokemonFullData> resOld = res;
    res = [];

    for (PokemonFullData pokemon in resOld) {
      PokemonType? type1 = pokemon.pokemonData.firstType,
          type2 = pokemon.pokemonData.secondType;

      bool added = false;
      if (type1 != null && searchConfig.types[type1]!) {
        res.add(pokemon);
        added = true;
      }
      if (!added && type2 != null && searchConfig.types[type2]!) {
        res.add(pokemon);
      }
    }
    // Filter by favorite
    if (searchConfig.isFavorites) {
      resOld = res;
      res = [];

      for (PokemonFullData pokemon in resOld) {
        if (pokemon.userData?.isFavorite ?? false) {
          res.add(pokemon);
        }
      }
    }
    // Filter by generation
    resOld = res;
    res = [];
    for (PokemonFullData pokemon in resOld) {
      int gen = pokemon.pokemonData.generation;
      if (searchConfig.generations[gen] ?? false) {
        res.add(pokemon);
      }
    }
    return res;
  }

  Future<List<PokemonOnlineData>?> getOnlinePokemon(int id) async {
    List<PokemonOnlineData>? data =
        await ApiPokedexService().getPokemonData(id);
    return data;
  }
}
