import 'package:flutter/material.dart';
import 'package:krizal_inventory/pages/model/cart_item.dart';
import '../checkout.dart';

const CART_BAR_HEIGHT = 48.0;

class CartValueBar extends StatelessWidget {
  final double cartValue;
  final List<CartItem> cartItemOrder;

  const CartValueBar({Key key, this.cartValue, this.cartItemOrder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () { 
          Navigator.push(context, 
              new MaterialPageRoute(builder: (context) => CheckoutOrders(cartValue: cartValue, cartItemOrder: cartItemOrder))
          );
        },
        child : AnimatedContainer(
          height: CART_BAR_HEIGHT,
          duration: Duration(milliseconds: 300),
          transform: Matrix4.translationValues(
              0, cartValue != 0 ? 0 : CART_BAR_HEIGHT, 0),
          color: Colors.green,
          child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0),
                    child: Text(               
                      cartValue != 0
                          ? 'Cart value Rp ${_getCartValue()} '
                          : '',
                      style: TextStyle(color: Colors.white,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    )
                  ),
                ],
              ),
        ),
    );
  }

  String _getCartValue() => cartValue.toStringAsFixed(2);
}