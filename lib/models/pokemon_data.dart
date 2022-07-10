import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/core/constants.dart';
import 'package:pokedex/models/csv_handler.dart';
import 'package:pokedex/models/graph.dart';
import 'package:pokedex/models/pokemon_data_handler.dart';
import 'package:pokedex/core/utils.dart';

import 'package:stack/stack.dart' as stack;

class Pokemon extends Equatable {
  late final int number;
  final String name;
  final PokemonType? firstType;
  final PokemonType? secondType;
  final int hp;
  final int attack;
  final int defense;
  final int specialAttack;
  final int specialDefense;
  final int speed;
  final int generation;
  final bool isLegendary;
  final int? evolvesFrom;
  final List<int>? evolvesTo;

  Pokemon(
      {required this.number,
      required this.name,
      required this.firstType,
      this.secondType,
      required this.hp,
      required this.attack,
      required this.defense,
      required this.specialAttack,
      required this.specialDefense,
      required this.speed,
      required this.generation,
      this.isLegendary = false,
      required this.evolvesFrom,
      required String evolvesTo})
      : evolvesTo = convertToIntListFromString(evolvesTo);

  Pokemon.fromList(List<dynamic> data)
      : this(
          number: data[0],
          name: data[1],
          firstType: typeFromString(data[2]),
          secondType: typeFromString(data[3]),
          hp: data[5],
          attack: data[6],
          defense: data[7],
          specialAttack: data[8],
          specialDefense: data[9],
          speed: data[10],
          generation: data[11],
          isLegendary: data[12] == "FALSE" ? false : true,
          evolvesFrom: customIntParse(data[13]),
          evolvesTo: data[14],
        );

  String getImagePath() {
    //final maxSvgIndex = -1;
    return "assets/normal/$number.png";
  }

  Graph getEvolutionChart() {
    Graph evolutionGraph = Graph.empty();
    int currentID = number;
    int? parentID = evolvesFrom;

    while (parentID != null) {
      List? a = CSVHandler.getByFieldValue(0, parentID, pathToPokemonCsv);
      currentID = a?[0];
      parentID = customIntParse(a?[13]);
    }

    List? highestParentRaw =
        CSVHandler.getByFieldValue(0, currentID, pathToPokemonCsv);

    Pokemon highestParent = Pokemon.fromList(highestParentRaw!);
    evolutionGraph.rootID = highestParent.number;
    // Now, by having the root of the tree, we can build a graph by using DFS
    stack.Stack<Pokemon> pokemonStack = stack.Stack<Pokemon>();
    pokemonStack.push(highestParent);

    while (pokemonStack.isNotEmpty) {
      Pokemon parent = pokemonStack.pop();
      evolutionGraph.addNode(
          null, parent.number, Node(parent, null, parent.evolvesTo ?? []));
      for (int childID in parent.evolvesTo ?? []) {
        Pokemon? childPokemon =
            PokemonDataHandler.getPokemonById(childID)?.pokemonData;
        if (childPokemon != null) {
          pokemonStack.push(childPokemon);
        }
      }
    }

    return evolutionGraph;
  }

  @override
  String toString() {
    return "<Pokemon | id: $number | name: $name>";
  }

  @override
  List<Object?> get props => [number];
}

enum PokemonType {
  bug,
  dark,
  dragon,
  electric,
  fairy,
  fighting,
  fire,
  flying,
  ghost,
  grass,
  ground,
  ice,
  normal,
  poison,
  psychic,
  rock,
  steel,
  water
}

String typeToString(PokemonType type) {
  return type.toString().split('.')[1];
}

PokemonType? typeFromString(String type) {
  type = type.toLowerCase();
  for (PokemonType ptype in PokemonType.values) {
    if (typeToString(ptype) == type) {
      return ptype;
    }
  }
  return null;
}

Color? getTypeColor(PokemonType? type) {
  if (type == null) return null;
  Map<PokemonType, String> typeToColor = {
    PokemonType.bug: "A6B91A",
    PokemonType.dark: "705746",
    PokemonType.dragon: "6F35FC",
    PokemonType.electric: "F7D02C",
    PokemonType.fairy: "D685AD",
    PokemonType.fighting: "C22E28",
    PokemonType.fire: "EE8130",
    PokemonType.flying: "A98FF3",
    PokemonType.ghost: "735797",
    PokemonType.grass: "7AC74C",
    PokemonType.ground: "E2BF65",
    PokemonType.ice: "96D9D6",
    PokemonType.normal: "A8A77A",
    PokemonType.poison: "A33EA1",
    PokemonType.psychic: "F95587",
    PokemonType.rock: "B6A136",
    PokemonType.steel: "B7B7CE",
    PokemonType.water: "6390F0",
  };
  return typeToColor[type] == null
      ? null
      : Color(int.parse("0xFF" + typeToColor[type]!));
}
