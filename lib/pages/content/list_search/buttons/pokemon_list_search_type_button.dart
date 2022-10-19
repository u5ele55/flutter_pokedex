import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_list/list_bloc.dart';
import 'package:pokedex/models/pokemon_data.dart';

class PokemonTypeButton extends StatelessWidget {
  const PokemonTypeButton(this.type, {Key? key}) : super(key: key);

  final PokemonType type;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(
      builder: (context, state) {
        bool isActive = state.searchConfig.types[type]!;
        return TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((_) {
              return isActive
                  ? getTypeColor(type)
                  : getTypeColor(type)!.withAlpha(100);
            }),
          ),
          onPressed: () {
            final newConfig = state.searchConfig.copy();
            newConfig.types[type] = !isActive;
            context.read<ListBloc>().add(ListQueryChanged(newConfig));
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              type.toString().split('.')[1],
              style: TextStyle(
                letterSpacing: .5,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.black : Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }
}
