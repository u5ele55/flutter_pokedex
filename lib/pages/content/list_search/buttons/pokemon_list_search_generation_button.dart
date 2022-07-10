import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_list/list_bloc.dart';
import 'package:pokedex/core/utils.dart';

class PokemonGenerationFilterButton extends StatelessWidget {
  const PokemonGenerationFilterButton(this.generation, {Key? key})
      : super(key: key);
  final int generation;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(
      builder: (context, state) {
        bool isActive = state.searchConfig.generations[generation] ?? false;
        return TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((_) {
              return isActive
                  ? Colors.amberAccent
                  : Colors.amberAccent.withAlpha(100);
            }),
          ),
          onPressed: () {
            final newConfig = state.searchConfig.copy();
            newConfig.generations[generation] = !isActive;
            context.read<ListBloc>().add(ListQueryChanged(newConfig));
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              toRomanNumber(generation),
              style: TextStyle(
                letterSpacing: 1,
                fontFamily: "Pokemon Solid",
                fontSize: 22,
                color: isActive ? Colors.black : Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }
}
