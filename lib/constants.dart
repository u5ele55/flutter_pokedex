import 'package:flutter/material.dart';

const Color pokeballTopColor = Color.fromRGBO(238, 27, 36, 1);
const Color yellowPokemonColor = Color.fromRGBO(255, 203, 5, 1);
const Color bluePokemonColor = Color.fromRGBO(42, 117, 187, 1);

const int loadingDuration = 2000;

const String pathToPokemonCsv = 'assets/Pokemon_with_evolutions.csv';

const Map<String, int> pokemonMaxStats = {
  "hp": 255,
  "defense": 250,
  "speed": 200,
  "attack": 190,
};
