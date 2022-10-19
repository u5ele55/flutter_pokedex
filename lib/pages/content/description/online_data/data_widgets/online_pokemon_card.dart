import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_description/description_bloc.dart';
import 'package:pokedex/models/pokemon_json_data.dart';

class OnlinePokemonCard extends StatelessWidget {
  const OnlinePokemonCard(this.pokemon, {Key? key}) : super(key: key);
  final PokemonOnlineData pokemon;

  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadius.circular(15);
    return BlocBuilder<DescriptionBloc, DescriptionState>(
      builder: (context, state) => SizedBox(
        width: 120,
        child: Material(
          color: Colors.grey[300],
          borderRadius: borderRadius,
          shadowColor: Colors.grey,
          elevation: state.currentPokemon == pokemon ? 4 : 12,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: () => context
                .read<DescriptionBloc>()
                .add(ChangeCurrentPokemon(pokemon)),
            child: Column(
              children: [
                Ink(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: CachedNetworkImage(
                    imageUrl: pokemon.sprite!,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    pokemon.name!,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
