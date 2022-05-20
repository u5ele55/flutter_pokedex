import 'package:flutter/material.dart';
import 'package:pokedex/constants.dart';
import 'package:pokedex/models/csv_handler.dart';
import 'package:pokedex/models/graph.dart';
import 'package:pokedex/utils.dart';

class Pokemon {
  late final int number;
  final String name;
  final PokemonType? firstType;
  final PokemonType? secondType;
  final int hp;
  final int attack;
  final int defense;
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
          hp: data[4],
          speed: data[9],
          attack: data[5],
          defense: data[6],
          generation: data[11],
          firstType: typeFromString(data[2]),
          secondType: typeFromString(data[3]),
          isLegendary: data[12] == "FALSE" ? false : true,
          evolvesFrom: data[13] is num
              ? data[13].toInt()
              : int.tryParse(data[13].toString()),
          evolvesTo: data[14],
        );

  String getImagePath() {
    return "assets/normal/$number.png";
  }

  Graph getEvolutionChart() {
    Graph result = Graph.empty();
    int currentID = this.number;
    int? parentID = this.evolvesFrom;
    while (parentID != null) {
      List? a = CSVHandler.getByFieldValue(0, parentID, pathToPokemonCsv);
      currentID = a?[0];
      parentID = a?[13];
    }
    // TODO: start from currentID and build Graph of evolution
    return result;
  }
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

PokemonType? typeFromString(String type) {
  type = type.toLowerCase();
  PokemonType? ptype;
  switch (type) {
    case "bug":
      ptype = PokemonType.bug;
      break;
    case "dark":
      ptype = PokemonType.dark;
      break;
    case "dragon":
      ptype = PokemonType.dragon;
      break;
    case "electric":
      ptype = PokemonType.electric;
      break;
    case "fighting":
      ptype = PokemonType.fighting;
      break;
    case "fairy":
      ptype = PokemonType.fairy;
      break;
    case "fire":
      ptype = PokemonType.fire;
      break;
    case "flying":
      ptype = PokemonType.flying;
      break;
    case "ghost":
      ptype = PokemonType.ghost;
      break;
    case "grass":
      ptype = PokemonType.grass;
      break;
    case "ground":
      ptype = PokemonType.ground;
      break;
    case "ice":
      ptype = PokemonType.ice;
      break;
    case "normal":
      ptype = PokemonType.normal;
      break;
    case "poison":
      ptype = PokemonType.poison;
      break;
    case "psychic":
      ptype = PokemonType.psychic;
      break;
    case "rock":
      ptype = PokemonType.rock;
      break;
    case "steel":
      ptype = PokemonType.steel;
      break;
    case "water":
      ptype = PokemonType.water;
      break;
    default:
      ptype = null;
  }
  return ptype;
}

Color? getTypeColor(PokemonType? type, {double opacity = 1}) {
  String? hexString;
  switch (type) {
    case PokemonType.bug:
      hexString = "A6B91A";
      break;
    case PokemonType.dark:
      hexString = "705746";
      break;
    case PokemonType.dragon:
      hexString = "6F35FC";
      break;
    case PokemonType.electric:
      hexString = "F7D02C";
      break;
    case PokemonType.fairy:
      hexString = "D685AD";
      break;
    case PokemonType.fighting:
      hexString = "C22E28";
      break;
    case PokemonType.fire:
      hexString = "EE8130";
      break;
    case PokemonType.flying:
      hexString = "A98FF3";
      break;
    case PokemonType.ghost:
      hexString = "735797";
      break;
    case PokemonType.grass:
      hexString = "7AC74C";
      break;
    case PokemonType.ground:
      hexString = "E2BF65";
      break;
    case PokemonType.ice:
      hexString = "96D9D6";
      break;
    case PokemonType.normal:
      hexString = "A8A77A";
      break;
    case PokemonType.poison:
      hexString = "A33EA1";
      break;
    case PokemonType.psychic:
      hexString = "F95587";
      break;
    case PokemonType.rock:
      hexString = "B6A136";
      break;
    case PokemonType.steel:
      hexString = "B7B7CE";
      break;
    case PokemonType.water:
      hexString = "6390F0";
      break;
    case null:
      hexString = null;
      break;
  }

  final _getOpacityHex = (double opac) =>
      (opacity * 255).toInt().toRadixString(16).padLeft(2, '0');

  return hexString == null
      ? null
      : Color(int.parse("0x${_getOpacityHex(opacity)}" + hexString));
}
