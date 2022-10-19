import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_list/list_bloc.dart';

import 'pokemon_list_search_filters.dart';

class PokemonListSearchBlock extends StatelessWidget {
  const PokemonListSearchBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(
      builder: (context, state) {
        return SliverList(
          delegate: SliverChildListDelegate(
            [
              TextField(
                controller: state.searchConfig.searchFieldController,
                // Refresh state so filter function applies to the new value
                onChanged: (_) {
                  context
                      .read<ListBloc>()
                      .add(ListQueryChanged(state.searchConfig));
                },
                onSubmitted: (_) => {FocusScope.of(context).unfocus()},
                style: const TextStyle(fontSize: 32),
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
                      if (state
                          .searchConfig.searchFieldController.text.isNotEmpty)
                        {
                          state.searchConfig.searchFieldController.text = "",
                          context
                              .read<ListBloc>()
                              .add(ListQueryChanged(state.searchConfig))
                        }
                    },
                    splashRadius: 24,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const PokemonListSearchFilters()
            ],
          ),
        );
      },
    );
  }
}
