import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokedex/models/pokemon_json_data.dart';

const baseUrl = "https://pokeapi.glitch.me/v1/pokemon/";

class ApiPokedexService {
  Future<List<PokemonOnlineData>?> getPokemonData(int id) async {
    try {
      var url = Uri.parse(baseUrl + id.toString());
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<PokemonOnlineData> pData = [
          for (Map<String, dynamic> item in jsonDecode(response.body))
            PokemonOnlineData.fromJson(item)
        ];
        return pData;
      } else {
        return [];
      }
    } catch (e) {
      print("Error at ApiPokedexService: " + e.toString());
      return null;
    }
  }
}
