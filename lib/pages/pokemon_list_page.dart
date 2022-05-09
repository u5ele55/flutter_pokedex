import 'package:flutter/material.dart';
import 'package:pokedex/constants.dart';
import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/utils.dart';
import 'package:pokedex/widgets/drawer.dart';
import 'package:pokedex/widgets/page_loading_animation.dart';
import 'package:pokedex/widgets/pokemon_list_tile.dart';

class PokemonListPage extends StatefulWidget {
  static bool firstLaunch = true;
  const PokemonListPage({Key? key}) : super(key: key);

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  final searchFieldController = TextEditingController();
  bool _isLoadingWidgetVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => {PokemonListPage.firstLaunch = false});
    Future.delayed(
        Duration(milliseconds: loadingDuration),
        () => setState(
              () => _isLoadingWidgetVisible = false,
            ));
  }

  @override
  void dispose() {
    searchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _floatingActionButton(),
      body: Stack(
        children: [
          FutureBuilder(
            future: filterPokemonList(
                filterByUniqueId(readCsvFile(pathToPokemonCsv)),
                searchFieldController.text),
            builder: (context, AsyncSnapshot<List<List<dynamic>>> snapshot) {
              Widget child;
              if (snapshot.hasData) {
                final pokemonList = snapshot.data!;
                child = _pokemonGrid(pokemonList);
              } else if (snapshot.hasError) {
                child = SliverGrid.count(
                    crossAxisCount: 1,
                    children: [Text("Error: ${snapshot.error}")]);
              } else {
                child = SliverGrid.count(
                    crossAxisCount: 1,
                    children: const [CircularProgressIndicator()]);
              }
              return CustomScrollView(slivers: [
                // SafeArea
                _sizedBoxSliver(height: MediaQuery.of(context).padding.top),
                _searchEngine(),
                child
              ]);
            },
          ),
          const PokeballPageLoadingAnimation(
            duration: loadingDuration,
          )
        ],
      ),
      endDrawer: const MyDrawer(),
    );
  }

  _pokemonGrid(List pokemonList) => SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            var pokemonData = pokemonList[index];
            return PokemonListTile(
              pokemon: Pokemon(
                number: pokemonData[0],
                name: pokemonData[1],
                speed: pokemonData[9],
                attack: pokemonData[5],
                defense: pokemonData[6],
                generation: pokemonData[11],
                firstType: typeFromString(pokemonData[2]),
                secondType: typeFromString(pokemonData[3]),
                hp: pokemonData[4],
                isLegendary: pokemonData[12] == "FALSE" ? false : true,
              ),
            );
          },
          childCount: pokemonList.length,
        ),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
      );

  _searchEngine() => SliverList(
        delegate: SliverChildListDelegate([
          TextField(
            controller: searchFieldController,
            // Refresh state so filter function applies to the new value
            onChanged: (_) => setState(() {}),
            style: const TextStyle(letterSpacing: 2),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(width: 0.8)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                      width: 0.8, color: Theme.of(context).primaryColor)),
              hintText: "Search",
              prefixIcon: const Icon(
                Icons.search,
                size: 30,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => {
                  if (searchFieldController.text.isNotEmpty)
                    setState(() => {searchFieldController.text = ""})
                },
                splashRadius: 24,
              ),
            ),
          ),
        ]),
      );

  _sizedBoxSliver({double height = 24, double width = double.infinity}) =>
      SliverList(
        delegate:
            SliverChildListDelegate([SizedBox(height: height, width: width)]),
      );

  _floatingActionButton() => FutureBuilder(
        future: Future.delayed(
          const Duration(milliseconds: loadingDuration * 2 + 1000),
          () {},
        ),
        builder: (context, AsyncSnapshot<void> snapshot) {
          Widget? child;
          if (snapshot.connectionState == ConnectionState.waiting) {
            child = null;
          } else {
            child = Padding(
              key: const ValueKey(1),
              padding:
                  EdgeInsets.only(top: 8 + MediaQuery.of(context).padding.top),
              child: Builder(
                builder: (context) => FloatingActionButton(
                  onPressed: () => {Scaffold.of(context).openEndDrawer()},
                  child: const Icon(
                    Icons.menu,
                    size: 30,
                  ),
                  backgroundColor: Colors.grey[200],
                ),
              ),
            );
          }
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            child: child,
          );
        },
      );
}
