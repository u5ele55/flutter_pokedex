import 'dart:convert';
import 'dart:io';

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
  final fields = CsvToListConverter().convert(data);
  loadedPokemonData = fields;

  return fields;
}

Future<List<List<dynamic>>> filterByUniqueId(
    Future<List<List<dynamic>>> fields) async {
  List<List<dynamic>> filtered = [];
  List<List<dynamic>> readyFields = await fields;
  for (int i = 0; i < readyFields.length - 1; i++) {
    if (readyFields[i + 1][0] != readyFields[i][0])
      filtered.add(readyFields[i + 1]);
  }
  return filtered;
}

Future<List<List<dynamic>>> filterPokemonList(
    Future<List<List<dynamic>>> fields, String query) async {
  // If query is empty, return all data.
  if (query.isEmpty) {
    return fields;
  }
  List<List<dynamic>> res = [];
  // If query is just an integer - return pokemon with IDs, that contain that number.
  if (int.tryParse(query) != null) {
    var loaded = await fields;

    for (List<dynamic> row in loaded) {
      if (row[0].toString().contains(query)) {
        res.add(row);
      }
    }
  }

  return res;
}
