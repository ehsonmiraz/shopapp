import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/screens/overview_screen.dart';
class Auth extends ChangeNotifier{
  late  String _token;
  late DateTime _expirydate;
  late String _userId;
  bool get isAuthenticated{
    if(token!=null)
       return true;
    return false;
  }
  String? get token{
    if(_expirydate!=null && _expirydate.isAfter(DateTime.now()) && _token!=null)
      return _token;
    return null;

  }

   Future<void> login(String email,String password) async{

     final url=Uri.parse("https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBAfwwoxSDa8vcGikJHOVNJR2phvZTjdhU");
     try {
       final response = await http.post(
           url,
           body: json.encode({
             "email": email,
             "password": password,
             "returnSecureToken": true,
           })
       );
       final responsedData=json.decode(response.body);
       print(responsedData['error']['message']);
       if(responsedData['error']!=null) {
         print("ehson ehson");
         throw HttpException(responsedData['error']['message']);
       }
     }
     catch(error){
       throw error;
     }

     print("Logged in as $email");
  }

    Future<void> signup(String email,String password) async{
     final url=Uri.parse("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBAfwwoxSDa8vcGikJHOVNJR2phvZTjdhU");
     final responsedData;
     try {
        final response = await http.post(
           url,
           body: json.encode({
             "email": email,
             "password": password,
             "returnSecureToken": true,
           })
       );
      // print("Signed up as ${response.body.toString()}");
       responsedData=json.decode(response.body);
       print(responsedData['error']['message']);
        if(responsedData['error']!=null){
          print("ehson ehson");
          throw HttpException(responsedData['error']['message']);
     }
     }
     catch(error){
        throw  error;
     }

  }
}