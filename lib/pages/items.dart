import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'detailItems.dart';

class Items extends StatefulWidget {
  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            }
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
   return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('items').snapshots(),
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
   final record = Record.fromSnapshot(data);

   return Padding(
     key: ValueKey(record.name),
     padding: const EdgeInsets.only(left: 0,right: 16.0, top: 5.0, bottom: 5.0),
     child: Container(
       decoration: BoxDecoration(
         border: Border.all(color: Colors.grey[300]),
         borderRadius: BorderRadius.circular(5.0),
       ),
       child: ListTile(
         leading: Image.network(
            record.imageUrl,
            fit: BoxFit.cover,
            width: 76,
            height: 76,),
         title: Text(record.name),
         trailing: Text(record.quantity.toString()),
         //onTap: () => record.reference.updateData({'quantity': FieldValue.increment(-1)}),
          onTap: (){
            Navigator.push(context, 
              new MaterialPageRoute(builder: (context) => DetailItem(item: record,))
            );
          },       
       ),
     ),
   );
 }

}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('items').where('caseSearchList', arrayContains: query).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        else if(snapshot.data.documents.length == 0){
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "No Results Found.",
              ),
            )
          );
        }
        else{
          return _buildList(context, snapshot.data.documents);
        }
      }
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
   return ListView(
     padding: const EdgeInsets.only(top: 20.0),
     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
   );
 }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.only(left: 0,right: 16.0, top: 5.0, bottom: 5.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          leading: Image.network(
            record.imageUrl,
            fit: BoxFit.cover,
            width: 76,
            height: 76,),
          title: Text(record.name),
          trailing: Text(record.quantity.toString()),
          onTap: (){
            Navigator.push(context, 
              new MaterialPageRoute(builder: (context) => DetailItem(item: record,))
            );
          },       
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return Column();
  }
}


