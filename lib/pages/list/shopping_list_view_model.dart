import '../model/app_state.dart';
import '../model/cart_item.dart';
import '../redux/actions.dart';
import 'package:redux/redux.dart';

class ShoppingListViewModel {
  final double cartValue;
  final List<CartItem> cartItems;
  final List<CartItem> cartItemsOrder;
  final Function(CartItem) onProductAdded;
  final Function(CartItem) onProductRemoved;

  ShoppingListViewModel({
    this.cartValue,
    this.cartItems,
    this.cartItemsOrder,
    this.onProductAdded,
    this.onProductRemoved,
  });

  static build(Store<AppState> store) => ShoppingListViewModel(
        cartValue: _calculateCartValue(store.state.cartItems),
        cartItems: store.state.cartItems,
        cartItemsOrder: _getCartItemOrder(store.state.cartItems),
        onProductAdded: (cartItem) => store.dispatch(AddItemAction(cartItem)),
        onProductRemoved: (cartItem) => store.dispatch(RemoveItemAction(cartItem)),
      );

  static double _calculateCartValue(List<CartItem> cartItems) {
    return cartItems
        .map((cartItem) => cartItem.price * cartItem.quantity)
        .fold(0.0, (previous, next) => previous + next);
  }

  static List<CartItem> _getCartItemOrder(List<CartItem> cartItems) {
    List<CartItem> orderItem = cartItems.where((cartItem)=> cartItem.quantity > 0).toList();
    return orderItem;
  }
}