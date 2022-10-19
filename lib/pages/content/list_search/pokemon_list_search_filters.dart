import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_list/list_bloc.dart';
import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/core/constants.dart' as constants;
import 'package:pokedex/pages/content/list_search/buttons/pokemon_list_search_favorites_btn.dart';

import 'buttons/pokemon_list_search_choose_all_btn.dart';
import 'buttons/pokemon_list_search_generation_button.dart';
import 'buttons/pokemon_list_search_type_button.dart';

class PokemonListSearchFilters extends StatelessWidget {
  const PokemonListSearchFilters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(builder: (context, state) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey)),
        child: ExpandablePanel(
          header: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Filters : ${state.searchConfig.types.values.where((element) => element).length + (state.searchConfig.isFavorites ? 1 : 0)}",
              style: const TextStyle(
                fontSize: 32,
                fontFamily: "Merchant Copy",
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          collapsed: const SizedBox.shrink(),
          expanded: Column(
            children: [
              const PokemonChooseAllTypesButton(),
              // Type
              GridView.extent(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                maxCrossAxisExtent: 100,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: List.generate(
                  PokemonType.values.length,
                  (index) => PokemonTypeButton(PokemonType.values[index]),
                ),
              ),
              const SizedBox(height: 8),
              // Generation
              GridView.extent(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                maxCrossAxisExtent: 64,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: List.generate(
                  constants.maxPokemonGeneration,
                  (index) => PokemonGenerationFilterButton(index + 1),
                ),
              ),
              const SizedBox(height: 8),
              const PokemonFavoritesFilterButton(),
            ],
          ),
        ),
      );
    });
  }
}
