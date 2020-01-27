import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailItem extends StatefulWidget {
  final Record item;

  DetailItem({Key key, @required this.item}) : super(key: key);

  @override
  _DetailItemState createState() => _DetailItemState(item);
}

class _DetailItemState extends State<DetailItem> {
  Record item;

  _DetailItemState(this.item);

  void add() {
    setState(() {
      item.reference.updateData({'quantity': FieldValue.increment(1)});
    });
  }

  void minus() {
    setState(() {
      if (item.quantity != 0) 
        item.reference.updateData({'quantity': FieldValue.increment(-1)});
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Stock Quantity"),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Image.network(
              item.imageUrl,
              height: 200,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            new Text(
              item.name,
              style: TextStyle(fontSize: 24, height: 2.0),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: "btnAdd",
                  onPressed: minus,
                  child: new Icon(
                  const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                    color: Colors.black),
                  backgroundColor: Colors.white,
                ),
                buildItemQuantity(context, item),
                FloatingActionButton(
                  heroTag: "btnSub",
                  onPressed: add,
                  child: new Icon(Icons.add, color: Colors.black,),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),      
    );
  }

  Widget buildItemQuantity(BuildContext context, Record item) {
    return new StreamBuilder(
        stream: Firestore.instance.collection('items').document(item.reference.documentID).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("Loading");
          }
          var userDocument = snapshot.data;
          return new Text(userDocument["quantity"].toString(), style: new TextStyle(fontSize: 60.0));
        }
    );
  }

}

class Record {
  final String name;
  final int quantity;
  final String imageUrl;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['quantity'] != null),
        assert(map['imageUrl'] != null),
        name = map['name'],
        quantity = map['quantity'],
        imageUrl = map['imageUrl'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$quantity:$imageUrl>";
}