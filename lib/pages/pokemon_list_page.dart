import 'package:flutter/material.dart';
import 'package:pokedex/constants.dart' as constants;
import 'package:pokedex/models/csv_handler.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final searchFieldController = TextEditingController();
  String _lastSearchQuery = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => {PokemonListPage.firstLaunch = false});
  }

  @override
  void dispose() {
    searchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          FutureBuilder(
            future: filterPokemonList(
                filterByUniqueId(
                    CSVHandler.readCsvFile(constants.pathToPokemonCsv)),
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

              return GestureDetector(
                onPanDown: (details) => FocusScope.of(context).unfocus(),
                child: CustomScrollView(slivers: [
                  // SafeArea
                  _sizedBoxSliver(
                      height: MediaQuery.of(context).padding.top + 8),
                  _searchEngine(),
                  child
                ]),
              );
            },
          ),
          _floatingActionButton(),
          const PokeballPageLoadingAnimation(
            duration: constants.loadingDuration,
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
              pokemon: Pokemon.fromList(pokemonData),
            );
          },
          // Is this really helped to boost performance??
          addAutomaticKeepAlives: false,
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
            onChanged: (_) => {
              if (searchFieldController.text != _lastSearchQuery)
                setState(() {
                  _lastSearchQuery = searchFieldController.text;
                })
            },
            onSubmitted: (_) => {FocusScope.of(context).unfocus()},
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

  _floatingActionButton() => Positioned(
        bottom: 16,
        right: 12,
        child: IconButton(
          onPressed: () => {_scaffoldKey.currentState?.openEndDrawer()},
          icon: const Icon(
            Icons.menu,
            size: 40,
          ),
        ),
      );
}
