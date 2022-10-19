part of 'description_bloc.dart';

enum DescriptionStatus {
  initial,
  success,
  failure_404,
  failure_other,
}

class DescriptionState extends Equatable {
  const DescriptionState({
    this.status = DescriptionStatus.initial,
    this.pokemonData = const <PokemonOnlineData>[],
    this.currentPokemon,
  });

  final DescriptionStatus status;
  final List<PokemonOnlineData> pokemonData;
  final PokemonOnlineData? currentPokemon;

  DescriptionState copyWith(
      {DescriptionStatus? status,
      List<PokemonOnlineData>? pokemonData,
      PokemonOnlineData? currentPokemon}) {
    return DescriptionState(
      status: status ?? this.status,
      pokemonData: pokemonData ?? this.pokemonData,
      currentPokemon: currentPokemon ?? this.currentPokemon,
    );
  }

  @override
  String toString() {
    return '''DescriptionState { status: $status, pokemonData: $pokemonData, currentPokemon: $currentPokemon''';
  }

  @override
  List<Object> get props =>
      [status, pokemonData, currentPokemon ?? PokemonOnlineData()];
}
