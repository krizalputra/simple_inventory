import 'cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppState {
  static var empty = AppState([
    CartItem(1, 'TV', 0, 79000),
    CartItem(2, 'Kulkas', 0, 229000),
    CartItem(3, 'Komputer', 0, 139000),
    CartItem(4, 'Vas Bunga', 0, 219000),
    CartItem(5, 'Mouse', 0, 79000),
    CartItem(6, 'Keyboard', 0, 229000),
    CartItem(7, 'Flashdisk', 0, 139000),
    CartItem(8, 'Hard Disk', 0, 219000),
    CartItem(9, 'SSD', 0, 139000),
    CartItem(10, 'RAM 8GB', 0, 219000),
  ]);

  final List<CartItem> cartItems;

  AppState(this.cartItems);
}