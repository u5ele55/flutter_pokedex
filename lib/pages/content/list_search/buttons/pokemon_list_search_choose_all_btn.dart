import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_list/list_bloc.dart';

class PokemonChooseAllTypesButton extends StatelessWidget {
  const PokemonChooseAllTypesButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(builder: (context, state) {
      return TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((_) {
            return _getAllBitAnd(state.searchConfig.types.values)
                ? Colors.grey[500]
                : Colors.grey[300];
          }),
        ),
        onPressed: () {
          bool value = !_getAllBitAnd(state.searchConfig.types.values);
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
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: _getAllBitAnd(state.searchConfig.types.values)
                ? Colors.black
                : Colors.grey,
          ),
        ),
      );
    });
  }

  _getAllBitAnd(Iterable<bool> a) => a.every((element) => element);
}
