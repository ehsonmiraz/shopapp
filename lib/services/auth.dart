import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/screens/overview_screen.dart';
class Auth extends ChangeNotifier{
    String? _token;
    DateTime? _expirydate;
    String? _userId;
    bool get isAuthenticated{
    if(token!=null)
       return true;
    return false;
  }
    String? get token{
    if(_expirydate!=null && _expirydate!.isAfter(DateTime.now()) && _token!=null)
      return _token;
    return null;

  }
    String? get userId{
      if(_expirydate!=null && _expirydate!.isAfter(DateTime.now()) && _userId!=null)
        return _userId;
      return null;
    }

    Future<void> login(String email,String password) async{
     print("in login $password");
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
       print(responsedData);
       if(responsedData['error']!=null) {
         print("ehson ehson");
         throw HttpException(responsedData['error']['message']);
       }
       _userId=responsedData['localId'];
       _token=responsedData['idToken'];
       _expirydate= DateTime.now().add(Duration(seconds:int.parse(responsedData['expiresIn']) ));
       print("no error in try");
       notifyListeners();
     }
     catch(error){
       throw error;
     }

     print("Logged in as $email");
  }

    Future<void> signup(String email,String password) async{
    print("email : $email  pass: $password");
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

       responsedData=json.decode(response.body);
        print("Signed up as ${responsedData}");
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
    void logOut(){
      _token=null;
      _userId=null;
      _expirydate=null;
      notifyListeners();
    }
}