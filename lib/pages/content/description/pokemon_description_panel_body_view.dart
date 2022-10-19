import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_description/description_bloc.dart';
import 'package:pokedex/models/pokemon_data.dart';
import 'package:pokedex/core/utils.dart';
import 'package:pokedex/widgets/circle_loading.dart';
import 'package:pokedex/widgets/stroke_text.dart';

class DescriptionPanelBodyView extends StatelessWidget {
  const DescriptionPanelBodyView(this.pokemon, {Key? key}) : super(key: key);
  final Pokemon pokemon;
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(child: Container(), flex: 1),
        Expanded(
          flex: 3,
          child: BlocBuilder<DescriptionBloc, DescriptionState>(
            builder: (context, state) {
              if (state.status == DescriptionStatus.success &&
                  state.currentPokemon!.sprite != null) {
                return CachedNetworkImage(
                  imageUrl: state.currentPokemon!.sprite!,
                  placeholder: (context, url) => const CircleLoading(size: 32),
                  errorWidget: (context, url, err) =>
                      Image.asset(pokemon.getImagePath()),
                );
              }
              return Image.asset(pokemon.getImagePath());
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 128,
                padding: const EdgeInsets.only(left: 12),
                child: BlocBuilder<DescriptionBloc, DescriptionState>(
                  builder: (context, state) {
                    if (state.status == DescriptionStatus.success &&
                        state.currentPokemon!.gen != null) {
                      return _genText(state.currentPokemon!.gen!);
                    }
                    return _genText(pokemon.generation);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 12),
                height: 128,
                child: StrokeText(
                  "#${pokemon.number}",
                  strokeColor: Colors.white,
                  strokeWidth: 6,
                  style: TextStyle(
                    color: (getTypeColor(pokemon.firstType) ?? Colors.grey)
                        .withAlpha(128),
                    fontSize: 48,
                    letterSpacing: 6,
                    fontFamily: "Pokemon Solid",
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _genText(int gen) => StrokeText(
        toRomanNumber(gen),
        strokeWidth: 6,
        strokeColor: Colors.grey[600]!,
        style: const TextStyle(
          fontSize: 48,
          letterSpacing: 6,
          color: Colors.white,
          fontFamily: "Pokemon Solid",
        ),
      );
}
