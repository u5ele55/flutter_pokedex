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

  SearchConfig searchConfig = SearchConfig();
  String _lastSearchQuery = "";
  bool _filtersAND = true;
  bool _showScrollToTopButton = false;

  @override
  void initState() {
    _scrollController.addListener(() => setState(() {
          if (_scrollController.offset > 1200)
            _showScrollToTopButton = true;
          else
            _showScrollToTopButton = false;
        }));
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => {PokemonListPage.firstLaunch = false});
  }

  @override
  void dispose() {
    searchConfig.searchFieldController.dispose();
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
                searchConfig),
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
                child = SliverGrid.count(crossAxisCount: 1, children: const [
                  Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  )
                ]);
              }

              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      // SafeArea
                      _singleChildSliver(SizedBox(
                          height: MediaQuery.of(context).padding.top + 8,
                          width: double.infinity)),
                      ..._searchEngine(),
                      child
                    ],
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag),
              );
            },
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

  _searchEngine() => [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              TextField(
                controller: searchConfig.searchFieldController,
                // Refresh state so filter function applies to the new value
                onChanged: (_) => {
                  if (searchConfig.searchFieldController.text !=
                      _lastSearchQuery)
                    setState(() {
                      _lastSearchQuery =
                          searchConfig.searchFieldController.text;
                    })
                },
                onSubmitted: (_) => {FocusScope.of(context).unfocus()},
                style: const TextStyle(letterSpacing: 2),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(width: 0.8)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
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
                      if (searchConfig.searchFieldController.text.isNotEmpty)
                        setState(
                            () => searchConfig.searchFieldController.text = "")
                    },
                    splashRadius: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        _singleChildSliver(const SizedBox(
          height: 8,
        )),
        _singleChildSliver(_searchFilters()),
      ];

  _searchFilters() => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey)),
        child: ExpandablePanel(
          header: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Filters : ${searchConfig.types.values.where((element) => element).length + (searchConfig.isFavorites ? 1 : 0)}",
              style: const TextStyle(fontSize: 18, letterSpacing: 1.5),
            ),
          ),
          collapsed: const SizedBox.shrink(),
          expanded: Column(
            children: [
              TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((state) {
                      return _filtersAND ? Colors.grey[500] : Colors.grey[300];
                    }),
                  ),
                  onPressed: () {
                    searchConfig.types.forEach((key, value) {
                      searchConfig.types[key] = !_filtersAND;
                    });
                    _filtersAND = !_filtersAND;
                    setState(() {});
                  },
                  child: Text(
                    "Choose All",
                    style: TextStyle(
                        letterSpacing: 1,
                        fontSize: 16,
                        color: _filtersAND ? Colors.black : Colors.grey),
                  )),
              GridView.extent(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                maxCrossAxisExtent: 100,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: List.generate(PokemonType.values.length,
                    (index) => _typeButton(PokemonType.values[index])),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 64,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((state) {
                      return searchConfig.isFavorites
                          ? Colors.redAccent
                          : Colors.redAccent.withAlpha(100);
                    }),
                  ),
                  onPressed: () {
                    setState(() =>
                        searchConfig.isFavorites = !searchConfig.isFavorites);
                  },
                  child: Center(
                    child: Text(
                      "Favorites",
                      style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 16,
                          color: searchConfig.isFavorites
                              ? Colors.black
                              : Colors.grey),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );

  _typeButton(PokemonType type) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((state) {
          return searchConfig.types[type]!
              ? getTypeColor(type)
              : getTypeColor(type)!.withAlpha(100);
        }),
      ),
      onPressed: () {
        setState(() => searchConfig.types[type] = !searchConfig.types[type]!);
        _filtersAND = _getFiltersAND();
      },
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          type.toString().split('.')[1],
          style: TextStyle(
              letterSpacing: 1,
              fontSize: 16,
              color: searchConfig.types[type]! ? Colors.black : Colors.grey),
        ),
      ),
    );
  }

  _getFiltersAND() {
    return searchConfig.types.values.every((element) => element);
  }

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
