import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_description/description_bloc.dart';

class TryAgainLoadOnlineData extends StatelessWidget {
  const TryAgainLoadOnlineData(this.id, {Key? key}) : super(key: key);
  final int id;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.read<DescriptionBloc>().add(LoadDescriptionOnlineData(id)),
      child: const Text(
        "Unable to fetch data. Tap here to try again.",
        style: TextStyle(fontSize: 32, color: Colors.redAccent),
        textAlign: TextAlign.center,
      ),
    );
  }
}
