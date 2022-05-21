import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:pokedex/models/graph.dart' as customGraph;
import 'package:pokedex/widgets/pokemon_list_tile.dart';
import 'package:pokedex/widgets/progress_bar_with_title.dart';
import 'package:stack/stack.dart' as stack;
import 'package:pokedex/constants.dart';
import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/widgets/stroke_text.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PokemonDescriptionPage extends StatefulWidget {
  const PokemonDescriptionPage({Key? key, required this.pokemon})
      : super(key: key);
  final Pokemon pokemon;

  @override
  State<PokemonDescriptionPage> createState() => _PokemonDescriptionPageState();
}

class _PokemonDescriptionPageState extends State<PokemonDescriptionPage> {
  double _panelOpenPercentage = 0.0;
  final _headerSize = 64.0;
  final _maxPanelHeightPercentage = 1.0;
  final _snapPointPercentage = .75;
  final _minPanelHeightPercentage = .4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        snapPoint: _snapPointPercentage,
        minHeight:
            _minPanelHeightPercentage * MediaQuery.of(context).size.height,
        maxHeight:
            _maxPanelHeightPercentage * MediaQuery.of(context).size.height,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
        panelBuilder: (sc) => ListView(
          controller: sc,
          //shrinkWrap: true,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: _headerSize,
              child: Center(
                child: StrokeText(
                  widget.pokemon.name,
                  style: Theme.of(context).textTheme.headline1?.merge(
                        const TextStyle(
                          shadows: [Shadow(color: Colors.white, blurRadius: 4)],
                          fontSize: 32,
                        ),
                      ),
                  strokeColor: bluePokemonColor,
                  strokeWidth: 4,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _evolGraph(),
              padding: const EdgeInsets.only(bottom: 16, right: 16),
            ),
            _statsBlock()
          ],
        ),
        onPanelSlide: (val) => setState(() => _panelOpenPercentage = val),
        body: Column(
          children: [
            Container(
              height: 12 +
                  MediaQuery.of(context).size.height *
                      (1 -
                          _minPanelHeightPercentage -
                          _panelOpenPercentage *
                              (_maxPanelHeightPercentage -
                                  _minPanelHeightPercentage)),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  end: Alignment.bottomLeft,
                  begin: Alignment.topRight,
                  colors: [
                    getTypeColor(widget.pokemon.firstType) ?? Colors.white,
                    Colors.white,
                    getTypeColor(widget.pokemon.secondType) ?? Colors.white,
                  ],
                ),
              ),
              // TODO: refactor this frustration
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Expanded(
                    flex: 4,
                    child: Image.asset(
                      widget.pokemon.getImagePath(),
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _evolGraph() {
    final Graph graph = Graph()..isTree = true;
    BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration()
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT)
      ..siblingSeparation = 10;

    customGraph.Graph evolutionTree = widget.pokemon.getEvolutionChart();
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

  evolutionNodeWidget(id) => Container(
        decoration: id != widget.pokemon.number
            ? null
            : BoxDecoration(boxShadow: [
                BoxShadow(
                  color: yellowPokemonColor.withAlpha(128),
                  blurRadius: 8,
                )
              ], borderRadius: BorderRadius.all(Radius.circular(10))),
        child: PokemonListTile(
          pokemon: Pokemon.fromList(getPokemonListById(id)),
          displayName: false,
          startOpacity: id != widget.pokemon.number ? 0.7 : 1,
        ),
      );

  _statsBlock() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProgressBarWithTitle(
              title: "HP",
              value: widget.pokemon.hp.toString(),
              progress: widget.pokemon.hp / pokemonMaxStats["hp"]!,
              color: Colors.red),
          const SizedBox(height: 8),
          ProgressBarWithTitle(
              title: "Attack",
              value: widget.pokemon.attack.toString(),
              progress: widget.pokemon.attack / pokemonMaxStats["attack"]!,
              color: Colors.blue),
          const SizedBox(height: 8),
          ProgressBarWithTitle(
              title: "Defense",
              value: widget.pokemon.defense.toString(),
              progress: widget.pokemon.defense / pokemonMaxStats["defense"]!,
              color: Colors.green),
          const SizedBox(height: 8),
          ProgressBarWithTitle(
              title: "Speed",
              value: widget.pokemon.speed.toString(),
              progress: widget.pokemon.speed / pokemonMaxStats["speed"]!,
              color: Colors.black),
        ],
      ),
    );
  }
}
