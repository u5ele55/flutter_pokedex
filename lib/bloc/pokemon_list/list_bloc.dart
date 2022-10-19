import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:pokedex/models/pokemon_data_handler.dart';
import 'package:pokedex/models/search_config.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListState()) {
    on<ListTilesLoaded>(
      _onTilesLoaded,
      transformer: droppable(),
    );
    on<ListQueryChanged>(_onQueryChanged);
    on<UserPokemonDataChanged>(_onUserPokemonChanged);
    on<ListRefresh>(_onRefresh);
  }

  Future<void> _onTilesLoaded(
      ListTilesLoaded event, Emitter<ListState> emit) async {
    if (state.hasReachedMax) return;

    if (state.status == ListStatus.initial) {
      final pokemons = await _fetchPokemons();
      return emit(state.copyWith(
        status: ListStatus.success,
        pokemons: pokemons,
        hasReachedMax: false,
        lastIndex: responseLength,
      ));
    }

    final List<PokemonFullData> pokemons = await _fetchPokemons(
        startIndex: state.lastIndex, searchConfig: state.searchConfig);
    return emit(pokemons.isEmpty
        ? state.copyWith(hasReachedMax: true)
        : state.copyWith(
            status: ListStatus.success,
            pokemons: List.of(state.pokemons)..addAll(pokemons),
            hasReachedMax: false,
            lastIndex: state.lastIndex + responseLength,
          ));
  }

  Future<void> _onRefresh(ListRefresh event, Emitter<ListState> emit) async {
    final pokemons = await _fetchPokemons();
    return emit(state.copyWith(
      status: ListStatus.success,
      pokemons: pokemons,
      hasReachedMax: pokemons.length < responseLength,
      lastIndex: responseLength,
    ));
  }

  Future<void> _onQueryChanged(
      ListQueryChanged event, Emitter<ListState> emit) async {
    final pokemons =
        await _fetchPokemons(startIndex: 0, searchConfig: event.searchConfig);

    return emit(state.copyWith(
      status: ListStatus.success,
      pokemons: pokemons,
      searchConfig: event.searchConfig,
      hasReachedMax: pokemons.length < responseLength,
      lastIndex: responseLength,
    ));
  }

  final responseLength = 20;
  Future<List<PokemonFullData>> _fetchPokemons(
      {int startIndex = 0, SearchConfig? searchConfig, int? length}) async {
    List<PokemonFullData> response = await PokemonDataHandler()
        .filterPokemonList(searchConfig ?? state.searchConfig);

    if (startIndex >= response.length) return [];
    return response.sublist(startIndex,
        min(startIndex + (length ?? responseLength), response.length));
  }

  Future<void> _onUserPokemonChanged(
      UserPokemonDataChanged event, Emitter<ListState> emit) async {
    final pokemons =
        await _fetchPokemons(startIndex: 0, length: state.lastIndex);
    return emit(state.copyWith(
      pokemons: pokemons,
    ));
  }
}
