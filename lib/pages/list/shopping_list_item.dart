import 'package:flutter/material.dart';
import '../model/cart_item.dart';

class ShoppingListItem extends StatelessWidget {
  final CartItem item;
  final Function(CartItem) onProductAdded;
  final Function(CartItem) onProductRemoved;

  ShoppingListItem({this.item, this.onProductAdded, this.onProductRemoved});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text('Price: Rp ${item.price} '),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () => onProductRemoved(item),
          ),
          Text(item.quantity.toString()),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => onProductAdded(item),
          ),
        ],
      ),
    );
  }
}