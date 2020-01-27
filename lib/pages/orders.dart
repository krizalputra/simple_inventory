import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'detailOrder.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        automaticallyImplyLeading: false,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
   return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('orders').snapshots(),
      builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
   return ListView(
     padding: const EdgeInsets.only(top: 20.0),
     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
   );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = RecordOrders.fromSnapshot(data);
    DateTime datetime = record.date.toDate();

    return Padding(
     key: ValueKey(data.documentID),
     padding: const EdgeInsets.only(left: 16.0,right: 16.0, top: 5.0, bottom: 5.0),
     child: Container(
       decoration: BoxDecoration(
         border: Border.all(color: Colors.grey[300]),
         borderRadius: BorderRadius.circular(5.0),
       ),
       child: ListTile(   
          leading: Icon(Icons.note),
          title: Text("No : " + data.documentID),    
          subtitle: Text("Ordered: " + datetime.day.toString() + "-" + datetime.month.toString() + "-" + datetime.year.toString()),      
          onTap: (){            
            print(record.items[0].runtimeType);
            Navigator.push(context, 
              new MaterialPageRoute(builder: (context) => DetailOrder(orderList: record,))
            );
          },       
       ),
     ),
   );
  }

}

