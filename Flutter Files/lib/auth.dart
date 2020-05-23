import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart/http_exception.dart';

class Auth with ChangeNotifier {
  String token;
  DateTime time;
  String id;
  Timer timer;
  bool get isAuth {
    return gettoken != null;
  }

  String get gettoken {
    if (time != null && token != null && time.isAfter(DateTime.now())) {
      return token;
    }
    return null;
  }

String get userid{
  return id;
}


  Future<void> signup(String email, String password) async {
    try {
      const url =
          'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBzukOQymzp6lQYDwtR-drK_otPSF3SJ1E';
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
  //    print(json.decode(response.body));
      final data = json.decode(response.body);
      if (data['error'] != null) {
    
        throw HttpExceptions(data['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      const url =
          'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBzukOQymzp6lQYDwtR-drK_otPSF3SJ1E';
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      print(json.decode(response.body));
      final data = json.decode(response.body);
      if (data['error'] != null) {
        throw HttpExceptions(data['error']['message']);
      }
       else {
        token = data['idToken'];
        id = data['localId'];
        time = DateTime.now().add(
          Duration(
            seconds: int.parse(data['expiresIn']),
          ),
        );
        autologout();
        
        notifyListeners();
  final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': token,
          'userId': id,
          'expiryDate': time.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
        }
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async {
    token=null;
    id=null;
  time=null;
    if(timer!=null){
    timer.cancel();
  timer=null;
  
  }
  notifyListeners();
  final prefs= await SharedPreferences.getInstance();
  prefs.clear();
 
  }


void autologout(){
  if(timer!=null){
    timer.cancel();
  }
  else
  {
    final remaining=time.difference(DateTime.now()).inSeconds;
    timer=Timer(Duration(seconds: remaining),logout);
  }
}




  Future<bool> tryauto() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    token = extractedUserData['token'];
    id = extractedUserData['userId'];
    time = expiryDate;
    notifyListeners();
    autologout();
    return true;
  }


}
