import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Product with ChangeNotifier{

  final String id;
  final String title;
  final String description;
  final double price;
  final String imgUrl;
  bool  isFavourite;

  void toggleFavourite(String token, String userId)async{
    final url= Uri.parse("https://shop-app-87fed-default-rtdb.firebaseio.com/user_favourite/$userId/${id}.json?auth=$token");
    try {
      final response = await http.put(url,
          body: json.encode(
              !isFavourite
          ));
      final responseData= json.decode(response.body);
      print(responseData);
      //if(responseData['error']!=null)

    }
    catch(error){
      throw error;
    }
    isFavourite=!isFavourite;
    notifyListeners();
  }
  Product({ required this.id,required this.title,required this.description,required this.price,required this.imgUrl,this.isFavourite=false});

}