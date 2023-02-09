import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopapp/screens/overview_screen.dart';

class Auth extends ChangeNotifier{
    String? _token;
    DateTime? _expirydate;
    String? _userId;
    Timer?  _logoutTimer;
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
         throw HttpException(responsedData['error']['message']);
       }

       _userId=responsedData['localId'];
       _token=responsedData['idToken'];
       _expirydate= DateTime.now().add(Duration(seconds:int.parse(responsedData['expiresIn'])));
       autoLogout();
       notifyListeners();
       final prefs= await SharedPreferences.getInstance();
       final userData=json.encode({
         'userId':_userId,
         'idToken':_token,
         'expiryDate':_expirydate!.toIso8601String(),
       });
       prefs.setString("userData",userData);
     }
     catch(error){
       throw error;
     }

     print("Logged in as $email");
  }
    Future<bool> tryLoggingIn() async{
      final prefs=  await SharedPreferences.getInstance();
      if(!prefs.containsKey('userData'))
        return false;
      final userData = json.decode(prefs.getString('userData')!) as Map<String,dynamic>;
      if(DateTime.parse(userData['expiryDate']).isBefore(DateTime.now())){
        return false;
      }

      _token=userData['idToken'];
      _expirydate=DateTime.parse(userData['expiryDate']);

      _userId=userData['userId'];
      autoLogout();
      notifyListeners();
      return true;

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
     logOut() async{
      print("logout ho rha he");
      _token=null;
      _userId=null;
      _expirydate=null;
      _logoutTimer!.cancel;
      final prefs= await SharedPreferences.getInstance();
     
      prefs.remove('userData');

      notifyListeners();
    }
    void autoLogout(){
       if(_logoutTimer!=null)
           _logoutTimer=null;
       _logoutTimer = Timer(
          Duration(seconds:_expirydate!.difference(DateTime.now()).inSeconds),
          logOut
      );
    }
}