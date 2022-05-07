import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/constants.dart';
import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/utils.dart';
import 'package:pokedex/widgets/drawer.dart';
import 'package:pokedex/widgets/page_loading_animation.dart';
import 'package:pokedex/widgets/pokeball_loading_circle.dart';
import 'package:pokedex/widgets/pokemon_list_tile.dart';

class PokemonListPage extends StatefulWidget {
  static bool firstLaunch = true;
  const PokemonListPage({Key? key}) : super(key: key);

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => {PokemonListPage.firstLaunch = false});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FutureBuilder(
          future: Future.delayed(
            const Duration(milliseconds: loadingDuration * 2 + 1000),
            () {
              return 1;
            },
          ),
          builder: (context, AsyncSnapshot<int> snapshot) {
            Widget? child;
            if (snapshot.connectionState == ConnectionState.waiting) {
              child = null;
            } else {
              child = Padding(
                key: ValueKey(1),
                padding: EdgeInsets.only(
                    top: 8 + MediaQuery.of(context).padding.top),
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
              duration: Duration(milliseconds: 1000),
              child: child,
            );
          }),
      body: Stack(
        children: [
          FutureBuilder(
            future: filterByUniqueId(readCsvFile("assets/Pokemon.csv")),
            builder: (context, AsyncSnapshot<List<List<dynamic>>> snapshot) {
              Widget child;
              if (snapshot.hasData) {
                final pokemonList = snapshot.data!;
                child = _pokemonGrid(pokemonList);
              } else if (snapshot.hasError) {
                child = Text("Error: ${snapshot.error}");
              } else {
                child = CircularProgressIndicator();
              }
              return child;
            },
          ),
          const PokeballPageLoadingAnimation(
            duration: loadingDuration,
          ),
        ],
      ),
      endDrawer: MyDrawer(),
    );
  }

  _pokemonGrid(List pokemonList) => GridView.builder(
        //shrinkWrap: true,
        physics: const ScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8),
        itemCount: pokemonList.length,
        itemBuilder: (context, index) {
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
      );
}
