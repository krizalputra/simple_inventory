import 'package:flutter/material.dart';
import 'package:krizal_inventory/pages/model/cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../pages/orders.dart';
import '../main.dart';

class CheckoutOrders extends StatefulWidget {
  final double cartValue;
  final List<CartItem> cartItemOrder;

  CheckoutOrders({Key key, @required this.cartValue,  @required this.cartItemOrder}) : super(key: key);

  @override
  _CheckoutOrdersState createState() => _CheckoutOrdersState(cartValue, cartItemOrder);
}

class _CheckoutOrdersState extends State<CheckoutOrders> {
  double cartValue;
  List<CartItem> cartItemOrder;

  _CheckoutOrdersState(this.cartValue, this.cartItemOrder);  

  void createRecord(BuildContext context) async{    
    DocumentReference ref = await Firestore.instance.collection("orders")
      .add({
        'date': Timestamp.now(),
        'items': cartItemOrder.map((item) => {
          "id": item.id,
          "name": item.name,
          "quantity": item.quantity,
          "price": item.price
        }).toList()
      }); 

    Navigator.push(context, 
      new MaterialPageRoute(builder: (context) => MyHomePage())
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout Order'),
      ),
      body: Column(        
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(top: 24.0),
            child: Text("Total : " + cartValue.toStringAsFixed(2),
              style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          new Expanded(
            child: new Container(
              child: new ListView(
                padding: const EdgeInsets.only(top: 20.0),
                children: cartItemOrder.map((item) => _buildListItem(context, item)).toList(),
              ),
            ),
          ),
          new Container(
            width: screenSize.width,
            child: new RaisedButton(
              child: new Text(
                'Create Order',
                style: new TextStyle(
                  color: Colors.white
                ),
              ),
              onPressed: (){
                createRecord(context);
              },
              color: Colors.green,
            ),
            margin: new EdgeInsets.only(
              left: 10.0, right: 10.0
            ),
          ),        
        ],
      ),      
    );
  }

  Widget _buildListItem(BuildContext context, CartItem item) {
    return ListTile(
      title: Text(item.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[          
          Text(item.quantity.toString() + " x " + item.price.toString()),          
        ],
      ),
    );
  }

}