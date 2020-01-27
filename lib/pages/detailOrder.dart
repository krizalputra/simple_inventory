import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DetailOrder extends StatefulWidget {
  final RecordOrders orderList;

  DetailOrder({Key key, @required this.orderList}) : super(key: key);

  @override
  _DetailOrderState createState() => _DetailOrderState(orderList);
}

class _DetailOrderState extends State<DetailOrder> {
  RecordOrders orderList;  

  _DetailOrderState(this.orderList);

  @override
  Widget build(BuildContext context) {  
    DateTime datetime = orderList.date.toDate();  

    double totalPrice =  orderList.items
        .map((cartItem) => cartItem['price'] * cartItem['quantity'])
        .fold(0.0, (previous, next) => previous + next);

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Order"),
      ),
      body: Column(        
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(left: 16.0,right: 16.0, top: 20.0, bottom: 5.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text("Date : " + datetime.day.toString() + "-" + datetime.month.toString() + "-" + datetime.year.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),),
                new Text("Total : " + totalPrice.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ), 
          ),                   
          new Expanded(
            child: new Container(
              child: new ListView(
                padding: const EdgeInsets.only(top: 20.0),
                children: orderList.items.map((item) => _buildListItem(context, Map<String, dynamic>.from(item))).toList(),
              ),
            ),
          ),          
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, Map<String, dynamic> item) {
    return ListTile(
      title: Text(item['name']),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[          
          Text(item['quantity'].toString() + " x " + item['price'].toString()),          
        ],
      ),
    );
  }
}

class RecordOrders{
  final Timestamp date;
  final List<dynamic> items;
  final DocumentReference reference;

  RecordOrders.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['date'] != null),
        assert(map['items'] != null),
        date = map['date'],
        items = map['items'];

  RecordOrders.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "RecordOrders<$date:$items>";

}