part of 'shop.dart';

class ShopHeader extends StatelessWidget {
  const ShopHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Shop",
              style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
            ),
            _balanceBlock(state.balance),
          ],
        ),
      ),
    );
  }

  Widget _balanceBlock(int? balance) => Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_balance_wallet,
          ),
          const SizedBox(width: 4),
          balance == null
              ? const CircleLoading()
              : Text(
                  "$balance \$",
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ],
      ));
}
