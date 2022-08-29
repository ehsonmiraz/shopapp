import 'package:flutter/material.dart';
import 'package:shopapp/models/http_exception.dart';
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
  String? _token;
  String? _userId;
  Order(this._token,this._userId);
  Map<String ,OrderItem> _items={};
  Map<String ,OrderItem> get items{
    return {..._items};
  }
  int  get itemCount {
    return _items.length;
  }

  Future<void> fetchAndSetItems() async{
    final url=Uri.parse("https://shop-app-87fed-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$_token");
    final Map<String ,OrderItem> loadedOrders= {};
    try{
      final response = await http.get(url);
      (json.decode(response.body) as Map<String,dynamic>).forEach((orderId, value) {
        loadedOrders.putIfAbsent(orderId, () => OrderItem(
            id:orderId,
            amount:value['amount'],
            dateTime:DateTime.parse(value['dateTime']),
            cartItems: (value['cartItems'] as List<dynamic>).map((cartItem) => CartItem(
                title: cartItem['title'],
                price: cartItem['price'],
                id: cartItem['id'],
                quantity: cartItem['quantity'],
            )).toList(),
        )
        );
        _items=loadedOrders;
        notifyListeners();
        print("sahi chla");
        //addItem(orderId:value['orderId'],amount:double.parse(value['amount']), cartItems:value['cartItems'] );
      }) ;
    }
    catch(error){
        print("ordered not $error");
    }
  }
  Future<void> addItem( double amount, List<CartItem> cartItems) async{
    final url=Uri.parse("https://shop-app-87fed-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$_token");
    final Map<String ,dynamic> cartItemMap= {};
    final timestamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode(
              {
                'amount': amount,
                'cartItems': cartItems.map((cartItem) => {
                              'id'    : cartItem.id,
                              'title' :cartItem.title,
                              'price':cartItem.price,
                              'quantity':cartItem.quantity
                              }).toList(),
                'dateTime':timestamp.toIso8601String(),
              }
          )
      );
      if(response.statusCode>=400)
        throw HttpException("Request couldn't be fulfilled");

      _items.putIfAbsent(json.decode(response.body)['name'], () => OrderItem(id: response.body, amount: amount, dateTime: timestamp, cartItems: cartItems));
      notifyListeners();
    }
    catch(error){
     print(error);
     throw error;
    }

  }
  void removeItem(String id){
    if(_items.containsKey(id))
      _items.remove(id);
    notifyListeners();
  }
}