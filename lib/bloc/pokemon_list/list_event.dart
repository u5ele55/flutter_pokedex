part of 'list_bloc.dart';

abstract class ListEvent extends Equatable {
  @override
  List get props => [];
}

class ListTilesLoaded extends ListEvent {}

class ListQueryChanged extends ListEvent {
  ListQueryChanged(this.searchConfig);
  final SearchConfig searchConfig;
}

class UserPokemonDataChanged extends ListEvent {
  final int id;
  UserPokemonDataChanged(this.id);
}

class ListRefresh extends ListEvent {}
