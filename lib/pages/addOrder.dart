import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';
import './list/shopping_list.dart';
import 'model/app_state.dart';
import 'redux/reducers.dart';
import 'redux/middleware.dart';
import 'package:redux/redux.dart';


class AddOrder extends StatelessWidget {
  final store = Store<AppState>(
    appStateReducers,
    initialState: AppState.empty,
    middleware: [
      storeCartItemsMiddleware,
    ],
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: Scaffold(
        appBar: AppBar(
          title: Text('ShoppingList'),
        ),
        body: ShoppingList(),
      ),
    );
  }
}

