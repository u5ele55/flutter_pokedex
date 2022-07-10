part of 'shop_bloc.dart';

enum ShopStatus {
  initial,
  loading,
  loaded,
}

class ShopState extends Equatable {
  const ShopState(
      {this.status = ShopStatus.initial, this.balance, this.catalogue});

  final ShopStatus status;
  final int? balance;
  final List<ShopPokeball>? catalogue;

  ShopState copyWith(
      {ShopStatus? status, int? balance, List<ShopPokeball>? catalogue}) {
    return ShopState(
        status: status ?? this.status,
        balance: balance ?? this.balance,
        catalogue: catalogue ?? this.catalogue);
  }

  @override
  String toString() {
    return '''ShopState { status: $status, balance: $balance''';
  }

  @override
  List<Object> get props => [status, balance ?? -1, catalogue ?? []];
}
