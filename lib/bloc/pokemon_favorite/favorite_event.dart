part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  @override
  List get props => [];
}

class ToggleFavorite extends FavoriteEvent {
  final int id;
  ToggleFavorite(this.id);
}

class ShowFavoriteLabel extends FavoriteEvent {
  final int id;
  ShowFavoriteLabel(this.id);
}
