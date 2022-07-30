import 'package:flutter/material.dart';
import '../providers/cart.dart';
import '../providers/product.dart';


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

  void addItem(double amount, List<CartItem> cartItems){
    String orderId=DateTime.now().toString();
    _items.putIfAbsent(orderId, () => OrderItem(id: orderId, amount: amount, dateTime: DateTime.now(), cartItems: cartItems));
    notifyListeners();
  }
  void removeItem(String id){
    if(_items.containsKey(id))
      _items.remove(id);
    notifyListeners();
  }
}