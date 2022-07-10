part of 'shop_bloc.dart';

abstract class ShopEvent extends Equatable {
  @override
  List get props => [];
}

class OpenShop extends ShopEvent {}

class BuyPokemon extends ShopEvent {
  final ShopPokeball purchase;
  BuyPokemon(this.purchase);
}
