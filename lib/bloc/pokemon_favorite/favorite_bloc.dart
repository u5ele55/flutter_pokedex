import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:pokedex/models/pokemon_data_handler.dart';
import 'package:pokedex/models/user_pokemons_sqlite.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(const FavoriteState()) {
    on<ToggleFavorite>(_onToggleFavorite);
    on<ShowFavoriteLabel>(_onShowFavorite);
  }

  Future<void> _onToggleFavorite(
      ToggleFavorite event, Emitter<FavoriteState> emit) async {
    final pokemonData = PokemonDataHandler.getPokemonById(event.id);
    bool newFavorite = !(pokemonData?.userData?.isFavorite ?? false);

    PokemonDataHandler().changeUserData(
      pokemonData?.userData ?? UserPokemon(event.id, 0, false),
      isFavorite: newFavorite,
      catched: pokemonData?.userData?.catched ?? 1,
    );

    return emit(state.copyWith(
      status: FavoriteStatus.success,
      isFavorite: newFavorite,
    ));
  }

  Future<void> _onShowFavorite(
      ShowFavoriteLabel event, Emitter<FavoriteState> emit) async {
    final pokemonData = PokemonDataHandler.getPokemonById(event.id);

    return emit(state.copyWith(
      status: FavoriteStatus.success,
      isFavorite: pokemonData?.userData?.isFavorite,
    ));
  }
}
