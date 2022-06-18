import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_list/list_bloc.dart';
import 'package:pokedex/models/pokemon_data.dart';

import 'pokemon_list_search_type_button.dart';

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
              style: const TextStyle(fontSize: 18, letterSpacing: 1.5),
            ),
          ),
          collapsed: const SizedBox.shrink(),
          expanded: Column(
            children: [
              TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((_) {
                      return _getAllBitAnd(state.searchConfig.types.values)
                          ? Colors.grey[500]
                          : Colors.grey[300];
                    }),
                  ),
                  onPressed: () {
                    bool value =
                        !_getAllBitAnd(state.searchConfig.types.values);
                    final newConfig = state.searchConfig.copy();
                    newConfig.types.forEach((key, _) {
                      newConfig.types[key] = value;
                    });
                    context.read<ListBloc>().add(ListQueryChanged(newConfig));
                  },
                  child: Text(
                    "Choose All",
                    style: TextStyle(
                        letterSpacing: 1,
                        fontSize: 16,
                        color: _getAllBitAnd(state.searchConfig.types.values)
                            ? Colors.black
                            : Colors.grey),
                  )),
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
              SizedBox(
                height: 64,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((_) {
                      return state.searchConfig.isFavorites
                          ? Colors.redAccent
                          : Colors.redAccent.withAlpha(100);
                    }),
                  ),
                  onPressed: () {
                    final newConfig = state.searchConfig.copy();
                    newConfig.isFavorites = !newConfig.isFavorites;
                    context.read<ListBloc>().add(ListQueryChanged(newConfig));
                  },
                  child: Center(
                    child: Text(
                      "Favorites",
                      style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 16,
                          color: state.searchConfig.isFavorites
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
    });
  }

  _getAllBitAnd(Iterable<bool> a) => a.every((element) => element);
}
