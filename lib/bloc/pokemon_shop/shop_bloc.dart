import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:pokedex/models/shop/shop_entry.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  ShopBloc() : super(const ShopState()) {
    on<OpenShop>(_onOpenShop);
    on<BuyPokemon>(_onBuyPokemon);
  }

  Future<void> _onOpenShop(OpenShop event, Emitter<ShopState> emit) async {
    emit(state.copyWith(
      status: ShopStatus.loaded,
      balance: 0,
      catalogue: [
        ShopTestPokeball(
            name: "Red", cost: 50, description: "Contains 1 or 2 pokemon."),
      ],
    ));
  }

  Future<void> _onBuyPokemon(BuyPokemon event, Emitter<ShopState> emit) async {
    bool ableToBuy = event.purchase.cost <= (state.balance ?? -1);
    print("buy: $ableToBuy");
    if (ableToBuy) {
      emit(state.copyWith(
        status: ShopStatus.loaded,
        balance: state.balance! - event.purchase.cost,
      ));
    }
  }
}
