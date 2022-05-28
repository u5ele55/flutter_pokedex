import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/constants.dart';
import 'package:pokedex/models/csv_handler.dart';
import 'package:pokedex/models/graph.dart';
import 'package:pokedex/utils.dart';

import 'package:stack/stack.dart' as stack;

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
          firstType: typeFromString(data[2]),
          secondType: typeFromString(data[3]),
          hp: data[5],
          attack: data[6],
          defense: data[7],
          speed: data[10],
          generation: data[11],
          isLegendary: data[12] == "FALSE" ? false : true,
          evolvesFrom: customIntParse(data[13]),
          evolvesTo: data[14],
        );

  String getImagePath() {
    return "assets/" +
        (number > maxSvgIndex ? "normal/$number.png" : "svg/$number.svg");
  }

  Widget getImageWidget({BoxFit? fit, double? height, double? width}) {
    final assetName = getImagePath();

    if (assetName.contains(".svg")) {
      return SvgPicture.asset(
        assetName,
        fit: fit ?? BoxFit.contain,
        height: height,
        width: width,
      );
    } else {
      return Image.asset(
        assetName,
        fit: fit ?? BoxFit.contain,
        height: height,
        width: width,
      );
    }
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
        List childList = getPokemonListById(childID);
        if (childList.isNotEmpty) {
          pokemonStack.push(Pokemon.fromList(childList));
        }
      }
    }

    return evolutionGraph;
  }

  @override
  String toString() {
    return "<Pokemon | id: $number | name: $name>";
  }
}

List getPokemonListById(int id) {
  return CSVHandler.getByFieldValue(0, id, pathToPokemonCsv) ?? [];
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
