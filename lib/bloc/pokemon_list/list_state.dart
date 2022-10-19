part of 'list_bloc.dart';

enum ListStatus { initial, success, failure }

class ListState extends Equatable {
  ListState({
    this.status = ListStatus.initial,
    SearchConfig? searchConfig,
    this.pokemons = const <PokemonFullData>[],
    this.hasReachedMax = false,
    this.lastIndex = 0,
  }) : searchConfig = searchConfig ?? SearchConfig();

  final ListStatus status;
  final SearchConfig searchConfig;
  final List<PokemonFullData> pokemons;
  final bool hasReachedMax;
  final int lastIndex;

  ListState copyWith({
    ListStatus? status,
    List<PokemonFullData>? pokemons,
    SearchConfig? searchConfig,
    bool? hasReachedMax,
    int? lastIndex,
  }) {
    return ListState(
      status: status ?? this.status,
      pokemons: pokemons ?? this.pokemons,
      searchConfig: searchConfig ?? this.searchConfig,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      lastIndex: lastIndex ?? this.lastIndex,
    );
  }

  @override
  String toString() {
    return '''ListState { status: $status, hasReachedMax: $hasReachedMax, lastIndex: $lastIndex, sConfig: $searchConfig''';
  }

  @override
  List get props => [
        status,
        pokemons,
        searchConfig,
        hasReachedMax,
        lastIndex,
      ];
}
