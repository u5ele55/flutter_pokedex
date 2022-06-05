import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:pokedex/constants.dart' as constants;
import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/widgets/pokemon_list_tile.dart';
import 'package:pokedex/widgets/progress_bar_with_title.dart';
import 'package:pokedex/widgets/stroke_text.dart';

import 'package:pokedex/models/graph.dart' as custom_graph;
import 'package:stack/stack.dart' as stack;

class PokemonDescriptionBlock extends StatelessWidget {
  const PokemonDescriptionBlock(this.pokemon, {Key? key, this.scrollController})
      : super(key: key);

  final Pokemon pokemon;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      //shrinkWrap: true,
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top + 8),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: StrokeText(
              pokemon.name,
              style: Theme.of(context).textTheme.headline1?.merge(
                    const TextStyle(
                      shadows: [Shadow(color: Colors.white, blurRadius: 4)],
                      fontSize: 32,
                    ),
                  ),
              strokeColor: constants.bluePokemonColor,
              strokeWidth: 4,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            children: [
              const SizedBox(height: 4),
              _headline("Stats"),
              _statsBlock(),
              const SizedBox(height: 16),
              _headline("Evolution chart"),
              const SizedBox(height: 16),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _evolGraph(),
          padding: const EdgeInsets.only(bottom: 16, right: 16),
        ),
      ],
    );
  }

  _evolGraph() {
    final Graph graph = Graph()..isTree = true;
    BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration()
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT)
      ..siblingSeparation = 10;

    custom_graph.Graph evolutionTree = pokemon.getEvolutionChart();
    graph.addNode(Node.Id(evolutionTree.rootID));

    stack.Stack<int> idStack = stack.Stack<int>();
    idStack.push(evolutionTree.rootID!);

    while (idStack.isNotEmpty) {
      int parent = idStack.pop();
      Node parentNode = Node.Id(parent);
      for (int childID in evolutionTree.getNode(parent)?.children ?? []) {
        graph.addEdge(parentNode, Node.Id(childID));
        idStack.push(childID);
      }
    }

    return GraphView(
      graph: graph,
      paint: Paint()
        ..color = Colors.grey
        ..strokeWidth = 1.5,
      algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
      builder: (Node node) {
        var a = node.key!.value;
        return evolutionNodeWidget(a);
      },
    );
  }

  evolutionNodeWidget(id) {
    Pokemon nextPokemon = Pokemon.fromList(getPokemonListById(id));
    double blockWidth = 192;
    return Column(
      children: [
        Container(
          height: blockWidth * 2 / 3,
          width: blockWidth,
          decoration: id != pokemon.number
              ? null
              : BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: constants.yellowPokemonColor.withAlpha(128),
                    blurRadius: 8,
                  )
                ], borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: PokemonListTile(
            pokemon: nextPokemon,
            displayName: false,
            startOpacity: id != pokemon.number ? 0.7 : 1,
          ),
        ),
        SizedBox(
          width: blockWidth,
          child: Center(
            child: StrokeText(nextPokemon.name,
                strokeWidth: 3,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  letterSpacing: 3,
                  color: Colors.white,
                )),
          ),
        )
      ],
    );
  }

  _statsBlock() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProgressBarWithTitle(
              title: "HP",
              value: pokemon.hp.toString(),
              progress: pokemon.hp / constants.pokemonMaxStats["hp"]!,
              color: Colors.red),
          const SizedBox(height: 8),
          ProgressBarWithTitle(
              title: "Attack",
              value: pokemon.attack.toString(),
              progress: pokemon.attack / constants.pokemonMaxStats["attack"]!,
              color: Colors.blue),
          const SizedBox(height: 8),
          ProgressBarWithTitle(
              title: "Defense",
              value: pokemon.defense.toString(),
              progress: pokemon.defense / constants.pokemonMaxStats["defense"]!,
              color: Colors.green),
          const SizedBox(height: 8),
          ProgressBarWithTitle(
              title: "Speed",
              value: pokemon.speed.toString(),
              progress: pokemon.speed / constants.pokemonMaxStats["speed"]!,
              color: Colors.black),
          const SizedBox(height: 8),
          ProgressBarWithTitle(
              title: "Sp. Attack",
              value: pokemon.specialAttack.toString(),
              progress: pokemon.specialAttack /
                  constants.pokemonMaxStats["sp_attack"]!,
              color: Colors.deepOrange),
          const SizedBox(height: 8),
          ProgressBarWithTitle(
              title: "Sp. Defense",
              value: pokemon.specialDefense.toString(),
              progress: pokemon.specialDefense /
                  constants.pokemonMaxStats["sp_defense"]!,
              color: Colors.deepPurple),
        ],
      ),
    );
  }

  StrokeText _headline(String text) => StrokeText(
        text,
        strokeWidth: 4,
        style: const TextStyle(
          fontSize: 32,
          color: Colors.white,
          letterSpacing: 5,
        ),
        textAlign: TextAlign.center,
      );
}
