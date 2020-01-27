import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'cart_value_bar.dart';
import 'shopping_list_item.dart';
import 'shopping_list_view_model.dart';
import '../model/app_state.dart';

class ShoppingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ShoppingListViewModel>(
      converter: (store) => ShoppingListViewModel.build(store),
      builder: (context, viewModel) {
        return Stack(
          children: <Widget>[
            ListView.builder(
              itemCount: viewModel.cartItems.length,
              itemBuilder: (context, position) => ShoppingListItem(
                    item: viewModel.cartItems[position],
                    onProductAdded: viewModel.onProductAdded,
                    onProductRemoved: viewModel.onProductRemoved,
                  ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CartValueBar(cartValue: viewModel.cartValue, cartItemOrder: viewModel.cartItemsOrder),
            ),
          ],
        );
      },
    );
  }
}
