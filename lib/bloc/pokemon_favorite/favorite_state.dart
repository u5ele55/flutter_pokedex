part of 'favorite_bloc.dart';

enum FavoriteStatus { initial, success, failure }

class FavoriteState extends Equatable {
  const FavoriteState({
    this.status = FavoriteStatus.initial,
    this.isFavorite,
  });

  final FavoriteStatus status;
  final bool? isFavorite;

  FavoriteState copyWith({FavoriteStatus? status, bool? isFavorite}) {
    return FavoriteState(
      status: status ?? this.status,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return '''FavoriteState { status: $status, isFavorite: $isFavorite''';
  }

  @override
  List<Object> get props => [status, isFavorite ?? false];
}
