import 'package:flutter/material.dart';

const Color pokeballTopColor = Color.fromRGBO(238, 27, 36, 1);
const Color yellowPokemonColor = Color.fromRGBO(255, 203, 5, 1);
const Color bluePokemonColor = Color.fromRGBO(42, 117, 187, 1);

const Duration loadingDuration = Duration(milliseconds: 1500);
const Duration slideDuration = Duration(milliseconds: 1000);
const Duration blinkDuration = Duration(milliseconds: 800);

const String pathToPokemonCsv = 'assets/Pokemon_with_evolutions.csv';

const Map<String, int> pokemonMaxStats = {
  "hp": 255,
  "defense": 250,
  "speed": 200,
  "attack": 190,
};

const int maxSvgIndex = 649;
