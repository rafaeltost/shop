import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget(this.cartItem, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Dismissible(
        key: ValueKey(cartItem.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          color: Theme.of(context).errorColor,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
        ),
        confirmDismiss: (_) {
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Excluir'),
                content: const Text('Remover o item?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Não'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Sim'),
                  )
                ],
              );
            },
          );
        },
        onDismissed: (_) {
          Provider.of<Cart>(context, listen: false)
              .removeItem(cartItem.productId);
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: FittedBox(
                child: Text(cartItem.price.toString()),
              ),
            ),
          ),
          title: Text(cartItem.name),
          subtitle: Text('Total: R\$ ${cartItem.quantity * cartItem.price}'),
          trailing: Text('${cartItem.quantity}x'),
        ),
      ),
    );
  }
}
