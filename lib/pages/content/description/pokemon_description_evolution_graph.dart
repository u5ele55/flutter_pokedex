import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/models/pokemon_data_handler.dart';
import 'package:pokedex/widgets/pokemon_list_tile.dart';
import 'package:pokedex/widgets/stroke_text.dart';

import 'package:pokedex/core/constants.dart' as constants;
import 'package:pokedex/models/graph.dart' as custom_graph;
import 'package:stack/stack.dart' as stack;

class PokemonEvolutionGraph extends StatelessWidget {
  const PokemonEvolutionGraph(this.pokemon, {Key? key}) : super(key: key);
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: _evolGraph(),
      padding: const EdgeInsets.only(bottom: 16, right: 16),
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
    Pokemon nextPokemon = PokemonDataHandler.getPokemonById(id)!.pokemonData;
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
            preferPNG: true,
          ),
        ),
        SizedBox(
          width: blockWidth,
          child: Center(
            child: StrokeText(
              nextPokemon.name,
              strokeWidth: 3,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                letterSpacing: 3,
                color: Colors.white,
                fontFamily: "Pokemon Solid",
              ),
            ),
          ),
        )
      ],
    );
  }
}
