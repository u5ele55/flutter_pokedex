part of 'shop.dart';

class PokemonShopTile extends StatelessWidget {
  const PokemonShopTile(this.data, {Key? key}) : super(key: key);
  final ShopPokeball data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<ShopBloc>().add(BuyPokemon(data)),
      child: Container(
        height: 80,
        width: 120,
        color: Colors.blueAccent,
        child: Text(
          data.name,
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}
