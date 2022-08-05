import 'package:flutter/material.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem{
  final String id;
  final double amount;
  final DateTime dateTime;
  final List<CartItem> cartItems;

  OrderItem({ required this.id,required this.amount,required this.dateTime,required this.cartItems});

}

class Order extends ChangeNotifier{
  Map<String ,OrderItem> _items={};
  Map<String ,OrderItem> get items{
    return {..._items};
  }
  int  get itemCount {
    return _items.length;
  }

  void fetchAndSetItems() async{
    final url=Uri.parse("https://shop-app-87fed-default-rtdb.firebaseio.com/orders.json");
    final Map<String ,OrderItem> loadedOrders= {};
    try{
      final response = await http.get(url);
      (json.decode(response.body) as Map<String,dynamic>).forEach((key, value) {
        loadedOrders.putIfAbsent(key, () => OrderItem(id:key,amount:value['amount'],dateTime:value['dateTime'],cartItems: value['cartItems']));
        //addItem(orderId:value['orderId'],amount:double.parse(value['amount']), cartItems:value['cartItems'] );
      }) ;
    }
    catch(error){

    }
  }
  void addItem( double amount, List<CartItem> cartItems) async{
    final url=Uri.parse("https://shop-app-87fed-default-rtdb.firebaseio.com/orders.json");
    final Map<String ,dynamic> cartItemMap= {};
    final timestamp = DateTime.now();
    cartItems.forEach((cartItem) {
      cartItemMap.putIfAbsent(cartItem.id, () => {
        'title' :cartItem.title,
        'price':cartItem.price,
        'quantity':cartItem.quantity
      });
    });
    try {
      final response = await http.post(url,
          body: json.encode(
              {
                'amount': amount,
                'cartItems': cartItemMap,
                'dateTime':timestamp.toString(),
              }
          )
      );
      _items.putIfAbsent(response.body, () => OrderItem(id: response.body, amount: amount, dateTime: timestamp, cartItems: cartItems));
      notifyListeners();
    }
    catch(error){
     print(error);
      // throw error;
    }

  }
  void removeItem(String id){
    if(_items.containsKey(id))
      _items.remove(id);
    notifyListeners();
  }
}