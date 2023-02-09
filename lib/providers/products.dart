import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shopapp/models/http_exception.dart';
import 'package:shopapp/providers/product.dart';
import'package:http/http.dart' as http ;
class Products with ChangeNotifier{
   final _token;
   final _userId;
   Products(this._token,this._userId);

    List<Product> _items=
  [

  ];

  List<Product> get items{
    return [..._items] ;
  }
  
  Future<void> fetchAndSetProducts([bool showOnlyUserProducts=false]) async{
    final String filterString= showOnlyUserProducts?'orderBy="creatorId"&equalTo="$_userId"':'';
    final urlFav= Uri.parse('https://shop-app-87fed-default-rtdb.firebaseio.com/user_favourite/$_userId.json?auth=$_token');
    final favRespose= await http.get(urlFav);
    final favStatusListMap= json.decode(favRespose.body);

    final urlProducts= Uri.parse('https://shop-app-87fed-default-rtdb.firebaseio.com/products.json?auth=$_token&$filterString');
    final response = await http.get(urlProducts);

    try{
      final dataListMap = json.decode(response.body) as Map<String,dynamic>;
      print(dataListMap);
      List<Product> loadedProducts=[];
      dataListMap.forEach((key, value ) {
        loadedProducts.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'].toDouble(),
            imgUrl: value['imgurl'],
            isFavourite: favStatusListMap[key] ==null ?false: favStatusListMap[key] as bool,
        )
        ) ;


        _items=loadedProducts;
      });
    }
    catch(error){
      print("this is the $error");
    }

    notifyListeners();

  }

  List<Product> get favItems {
    return _items.where((item) => item.isFavourite==true).toList();
  }
  int get itemsCount{
    return _items.length;
  }
  Future<void> addProduct1({required String title,required double price,required String description,required String imgUrl}) async{
    final url= Uri.parse("https://shop-app-87fed-default-rtdb.firebaseio.com/products.json?auth=$_token");
    try {
      final response = await http.post(url,
          body: json.encode({
            "title": title,
            "price": price,
            "description": description,
            "imgurl": imgUrl,
            "creatorId" : _userId
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
    final url= Uri.parse("https://shop-app-87fed-default-rtdb.firebaseio.com/products/${product.id}.json?auth=$_token");
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
    final url= Uri.parse("https://shop-app-87fed-default-rtdb.firebaseio.com/products/$id.json?auth=$_token");
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
      _items.insert(index, productBackup);
      notifyListeners();
      throw HttpException("Unable to delete product");
                }
    finally{
          productBackup = null;
          }
  }

  Future<void> addProduct({required String title,required double price,required String description,required String imgUrl}) async{
    final url= Uri.parse("https://shop-app-87fed-default-rtdb.firebaseio.com/products.json?auth=$_token");
    final data= json.encode(
      {
        "title" :title,
        "price" :price,
        "description" :description,
        "imgUrl" :imgUrl,
        "creatorId":_userId,
      }
    );
    try {
      final response = await http.post(url, body: data);
      final responseId=json.decode(response.body)['name'];
      _items.add(Product(
          id: responseId,
          title: title,
          description: description,
          price: price,
          imgUrl: imgUrl)
      );
      notifyListeners();
    }
    catch(error){
      print(error.toString());
      throw error;
    }
  }
}