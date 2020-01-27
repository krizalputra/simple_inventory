import 'package:flutter/material.dart';

import 'pages/items.dart';
import 'pages/orders.dart';
import 'pages/addItem.dart';
import 'pages/addOrder.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'Krizal Inventory',
     theme: ThemeData(
       primarySwatch: Colors.purple,
     ),
     home: MyHomePage(),
   );
 }
}

class MyHomePage extends StatefulWidget {
 @override
 _MyHomePageState createState() {
   return _MyHomePageState();
 }
}

class _MyHomePageState extends State<MyHomePage> {

  int currentTab = 0; // to keep track of active tab index
  final List<Widget> screens = [
    Items(),
    Orders()
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Items();

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if(currentTab == 0){
            Navigator.push(context, 
              new MaterialPageRoute(builder: (context) => AddItem())
            );
          }else if(currentTab == 1){
            Navigator.push(context, 
              new MaterialPageRoute(builder: (context) => AddOrder())
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(            
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Items(); // if user taps on this dashboard tab will be active
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.inbox,
                          color: currentTab == 0 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Items',
                          style: TextStyle(
                            color: currentTab == 0 ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Orders(); // if user taps on this dashboard tab will be active
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.add_shopping_cart,
                          color: currentTab == 1 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Orders',
                          style: TextStyle(
                            color: currentTab == 1 ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
   );
 }
}
