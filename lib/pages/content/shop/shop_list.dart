part of 'shop.dart';

class PokemonShopList extends StatelessWidget {
  const PokemonShopList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(builder: (context, state) {
      if (state.status == ShopStatus.initial) {
        return SimpleSliver(child: const CircleLoading());
      } else if (state.status == ShopStatus.loaded) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return PokemonShopTile(state.catalogue![index]);
            },
            childCount: state.catalogue?.length ?? 0,
          ),
        );
      } else {
        return SimpleSliver(child: const Text("no"));
      }
    });
  }
}
