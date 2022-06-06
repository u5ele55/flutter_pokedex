import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/models/search_config.dart';
import 'package:pokedex/models/user_pokemons_sqlite.dart';

Future<List<List<dynamic>>> filterByUniqueId(
    Future<List<List<dynamic>>> fields) async {
  List<List<dynamic>> filtered = [];
  print("filter");

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
    Future<List<List<dynamic>>> fields, SearchConfig searchConfig) async {
  // If query is empty, return all data.
  String query = searchConfig.searchFieldController.text;

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

  // Filtered by name and ids so far
  // Filtering by types:
  List<List<dynamic>> resWithTypes = [];

  for (List<dynamic> row in res) {
    String sType1 = row[2].toString().toLowerCase(),
        sType2 = row[3].toString().toLowerCase();
    PokemonType? type1 = typeFromString(sType1), type2 = typeFromString(sType2);

    bool added = false;
    if (type1 != null && searchConfig.types[type1]!) {
      resWithTypes.add(row);
      added = true;
    }
    if (!added && type2 != null && searchConfig.types[type2]!) {
      resWithTypes.add(row);
    }
  }
  // Filter by favorite
  if (searchConfig.isFavorites) {
    List<List<dynamic>> resWithTypesAndFavorites = [];
    List<UserPokemon> userPokemons = await UserPokemonsSQLite().getDBasList();

    for (List<dynamic> row in resWithTypes) {
      int number = row[0];
      for (UserPokemon userPokemon in userPokemons) {
        if (userPokemon.id == number && userPokemon.isFavorite) {
          resWithTypesAndFavorites.add(row);
          break;
        }
      }
    }

    return resWithTypesAndFavorites;
  }
  return resWithTypes;
}

List<int> convertToIntListFromString(String raw) {
  List<int> res = [];
  for (String item in raw.substring(1, raw.length - 1).split(', ')) {
    if (int.tryParse(item) != null) res.add(int.tryParse(item)!);
  }
  return res;
}

int? customIntParse(dynamic n) {
  return n is num ? n.toInt() : int.tryParse(n.toString());
}

String toRomanNumber(int n) {
  Map<int, String> table = {
    1000: 'M',
    900: 'CM',
    500: 'D',
    400: 'CD',
    100: 'C',
    50: 'L',
    40: 'XL',
    10: 'X',
    9: 'IX',
    5: 'V',
    4: 'IV',
    1: 'I',
  };

  String res = '';
  final numbers = table.keys.toList();

  for (int t = 0; t < numbers.length; t++) {
    int div = n ~/ numbers[t];
    n %= numbers[t];

    res += table[numbers[t]]! * div;
  }

  return res;
}
