import 'package:flutter/material.dart';
class CartItem{
  final title;
  final price;
  String id;
  int quantity;

  CartItem({
    required this.title,
    required this.price,
    required this.id,
    required this.quantity
});
}

class Cart  with ChangeNotifier{
   Map<String,CartItem> _items={};

  Map<String,CartItem> get items => {..._items} ;
  int get itemCount => _items==null ? 0 : _items.length;
  double get totalAmount {
    double sum=0.0;
    _items.forEach((key, cartItem) {
      sum+=cartItem.quantity*cartItem.price;
    });
    return sum ;

  }

  void addItem(String id,String title,double price ){
    if(_items.containsKey(id))
      _items.update(id, (cartItem) {
        cartItem.quantity++;
        return cartItem;
      });
    else
      _items.putIfAbsent(id, () => CartItem(title: title, price: price, id: id, quantity: 1));
    notifyListeners();
  }
  void removeItem(String id){
    _items.remove(id);
    notifyListeners();
  }

   void clear(){
    _items={};
    notifyListeners();
   }
}