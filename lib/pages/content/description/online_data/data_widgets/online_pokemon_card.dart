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
    return InkWell(
      onTap: () =>
          context.read<DescriptionBloc>().add(ChangeCurrentPokemon(pokemon)),
      child: BlocBuilder<DescriptionBloc, DescriptionState>(
        builder: (context, state) => Container(
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey[300],
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                color: state.currentPokemon == pokemon
                    ? Colors.black
                    : Colors.grey,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(4),
                child: CachedNetworkImage(
                    imageUrl: pokemon.sprite!, fit: BoxFit.fitWidth),
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
    );
  }
}
