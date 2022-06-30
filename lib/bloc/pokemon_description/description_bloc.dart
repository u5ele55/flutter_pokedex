import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:pokedex/models/pokemon_data_handler.dart';
import 'package:pokedex/models/pokemon_json_data.dart';

part 'description_event.dart';
part 'description_state.dart';

class DescriptionBloc extends Bloc<DescriptionEvent, DescriptionState> {
  DescriptionBloc() : super(DescriptionState()) {
    on<LoadDescriptionOnlineData>(_onLoadOnlineData);
  }

  Future<void> _onLoadOnlineData(
      LoadDescriptionOnlineData event, Emitter<DescriptionState> emit) async {
    final pokemonData = await PokemonDataHandler().getOnlinePokemon(event.id);

    if (pokemonData == null) {
      return emit(state.copyWith(
        status: DescriptionStatus.failure,
      ));
    }
    return emit(
      state.copyWith(
        status: DescriptionStatus.success,
        pokemonData: pokemonData,
        currentPokemon: pokemonData[0],
      ),
    );
  }
}
