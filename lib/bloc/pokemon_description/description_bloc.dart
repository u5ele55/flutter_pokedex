import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:pokedex/models/pokemon_data_handler.dart';
import 'package:pokedex/models/pokemon_json_data.dart';

part 'description_event.dart';
part 'description_state.dart';

class DescriptionBloc extends Bloc<DescriptionEvent, DescriptionState> {
  DescriptionBloc() : super(const DescriptionState()) {
    on<LoadDescriptionOnlineData>(_onLoadOnlineData);
    on<ChangeCurrentPokemon>(_onChangeCurrentPokemon);
  }

  Future<void> _onLoadOnlineData(
      LoadDescriptionOnlineData event, Emitter<DescriptionState> emit) async {
    emit(state.copyWith(
      status: DescriptionStatus.initial,
    ));
    final pokemonData = await PokemonDataHandler().getOnlinePokemon(event.id);

    if (pokemonData == null) {
      return emit(state.copyWith(
        status: DescriptionStatus.failure_other,
      ));
    }
    if (pokemonData.isEmpty) {
      return emit(state.copyWith(
        status: DescriptionStatus.failure_404,
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

  Future<void> _onChangeCurrentPokemon(
      ChangeCurrentPokemon event, Emitter<DescriptionState> emit) async {
    return emit(
      state.copyWith(
        status: DescriptionStatus.success,
        currentPokemon: event.pokemon,
      ),
    );
  }
}
