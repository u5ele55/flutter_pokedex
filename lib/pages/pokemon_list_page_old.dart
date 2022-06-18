import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/constants.dart' as constants;
import 'package:pokedex/models/csv_handler.dart';
import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/models/search_config.dart';
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
  final _scrollController = ScrollController();

  late Future<List<List<dynamic>>> _pokemonsCSV =
      filterByUniqueId(CSVHandler.readCsvFile(constants.pathToPokemonCsv));

  SearchConfig searchConfig = SearchConfig();
  String _lastSearchQuery = "";
  bool _filtersAND = true;
  bool _showScrollToTopButton = false;

  @override
  void initState() {
    //_scrollController.addListener(() => setState(() {
    //      _showScrollToTopButton = _scrollController.offset > 1200;
    //      debugPrint("a");
    //    }));
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => {PokemonListPage.firstLaunch = false});
  }

  @override
  void dispose() {
    searchConfig.searchFieldController.dispose();
    super.dispose();
  }

  void updateList() => setState(() {
        _pokemonsCSV = filterPokemonList(
            filterByUniqueId(
                CSVHandler.readCsvFile(constants.pathToPokemonCsv)),
            searchConfig);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: CustomScrollView(
                //controller: _scrollController,
                slivers: [
                  // SafeArea
                  _singleChildSliver(SizedBox(
                      height: MediaQuery.of(context).padding.top + 8,
                      width: double.infinity)),
                  ..._searchEngine(),

                  FutureBuilder(
                    future: _pokemonsCSV,
                    builder:
                        (context, AsyncSnapshot<List<List<dynamic>>> snapshot) {
                      Widget child;
                      if (snapshot.hasData) {
                        final pokemonList = snapshot.data!;
                        child = _pokemonGrid(pokemonList);
                      } else if (snapshot.hasError) {
                        child = _singleChildSliver(
                            Text("Error: ${snapshot.error}"));
                      } else {
                        child = _singleChildSliver(const Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        ));
                      }
                      return child;
                    },
                  )
                ],
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag),
          ),
          _floatingActionButton(),
          _scrollToTopButton(),
          const PokeballPageLoadingAnimation(
            duration: constants.loadingDuration,
          ),
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
              preferPNG: true,
            );
          },
          // Is this really helped to boost performance??
          addAutomaticKeepAlives: false,
          addSemanticIndexes: false,
          //addRepaintBoundaries: false,
          childCount: pokemonList.length,
        ),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
      );

  _searchEngine() => [];

  _singleChildSliver(Widget child) => SliverList(
        delegate: SliverChildListDelegate([child]),
      );

  _scrollToTopButton() => _showScrollToTopButton
      ? Positioned(
          bottom: 16,
          left: 12,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () => {
              _scrollController.animateTo(0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn)
            },
            child: const Icon(
              Icons.arrow_upward,
              size: 40,
            ),
          ),
        )
      : const SizedBox.shrink();

  _floatingActionButton() => Positioned(
        bottom: 16,
        right: 12,
        child: IconButton(
          onPressed: () => {
            FocusScope.of(context).unfocus(),
            _scaffoldKey.currentState?.openEndDrawer(),
          },
          icon: const Icon(
            Icons.menu,
            size: 40,
          ),
        ),
      );
}
