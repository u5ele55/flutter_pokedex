import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pokedex/constants.dart';
import 'package:pokedex/models/pokemon_data.dart';

Future<List<List<dynamic>>> readCsvFile(filepath) async {
  if (filepath == pathToPokemonCsv && loadedPokemonData != null) {
    print("i'm aoptimized!");
    return loadedPokemonData!;
  }
  final data = await rootBundle.loadString(filepath);
  final fields = const CsvToListConverter().convert(data);
  loadedPokemonData = fields;

  return fields;
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

Future<List<List<dynamic>>> filterPokemonList(
    Future<List<List<dynamic>>> fields, String query) async {
  // If query is empty, return all data.
  if (query.isEmpty) {
    return fields;
  }
  query = query.toLowerCase();
  List<List<dynamic>> res = [];
  // If query is just an integer - return pokemon with IDs, that contain that number.
  if (int.tryParse(query) != null) {
    var loaded = await fields;

    for (List<dynamic> row in loaded) {
      if (row[0].toString().contains(query)) {
        res.add(row);
      }
    }
  } else {
    // Query is pure string
    var loaded = await fields;

    for (List<dynamic> row in loaded) {
      if (row[1].toLowerCase().contains(query)) {
        res.add(row);
      }
    }
  }

  return res;
}
