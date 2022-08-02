import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shopapp/models/my_exception.dart';
import 'package:shopapp/providers/product.dart';
import'package:http/http.dart' as http ;
class Products with ChangeNotifier{


    List<Product> _items=
  [

  ];

  List<Product> get items{
    return [..._items] ;
  }

  Future<void> fetchAndSetProducts() async{
    final url= Uri.parse("https://shop-app-87fed-default-rtdb.firebaseio.com/products.json");
    final response = await http.get(url);
    final dataListMap = json.decode(response.body) as Map<String,dynamic>;
    List<Product> loadedProducts=[];
    dataListMap.forEach((key, value ) {
       loadedProducts.add(Product(
           id: key,
           title: value['title'],
           description: value['description'],
           price: value['price'].toDouble(),
           imgUrl: value['imgurl']
       )
       ) ;

    });
    _items=loadedProducts;
    print("items count he");
    for(int i=0;i<20;i++)
      {print("items count he : $itemsCount");}
    notifyListeners();

  }

  List<Product> get favItems {
    return _items.where((item) => item.isFavourite==true).toList();
  }
  int get itemsCount{
    return _items.length;
  }
  Future<void> addProduct({required String title,required double price,required String description,required String imgUrl}) async{
    final url= Uri.parse("https://shop-app-87fed-default-rtdb.firebaseio.com/products.json");
    try {
      final response = await http.post(url,
          body: json.encode({
            "title": title,
            "price": price,
            "description": description,
            "imgurl": imgUrl,
          })
      );
      final recordId=json.decode(response.body)['name'];
      _items.add(Product(id: recordId,
          title: title,
          description: description,
          price: price,
          imgUrl: imgUrl));
      notifyListeners();
    }
    catch(error){
      print(error.toString());
      throw error;
    }


  }

  Future<void> updateProduct(Product product) async{
    final url= Uri.parse("https://shop-app-87fed-default-rtdb.firebaseio.com/products/${product.id}.json");
    try {
      await http.patch(url,
          body: json.encode({
            "title": product.title,
            "price": product.price,
            "description": product.description,
            "imgurl": product.imgUrl,
          })
      );
      int index = _items.indexWhere((item) { return item.id == product.id; });
      print(index);
      _items[index]=product;
    }
    catch(error){
      throw error;
    }

    notifyListeners();
  }

  Future<void> deleteProduct(String id) async{
    final url= Uri.parse("https://shop-app-87fed-default-rtdb.firebaseio.com/products/$id.son");
    final index = _items.indexWhere((product) => (product.id==id));
    Product? productBackup= _items[index] ;
    _items.removeAt(index);
    notifyListeners();
    print("hello birather  1 ");
    try {
      final response = await http.delete(url);
       }
    catch(error){
      print("products catch");
      _items.insert(index, productBackup!);
      notifyListeners();
      throw MyException("Unable to delete product");
                }
    finally{
          productBackup = null;
          }
  }
}