import 'dart:convert';

import "package:http/http.dart" as http;

import 'package:flutter/material.dart';

class Product with ChangeNotifier{
final String id;
final String title;
final String description;
final double price;
final String imageUrl;
bool favourite;

Product({@required this.id,@required this.title,@required this.description,@required this.price,@required this.imageUrl,this.favourite=false});


  void _setFavValue(bool newValue) {
    favourite = newValue;
    notifyListeners();
  }

  Future<void> togglefavourite(String id,String auth, String userid) async {
    final oldStatus = favourite;
    favourite = !favourite;
    notifyListeners();
  final url = 'https://meals-app-1a5e5.firebaseio.com/UserFavourites/$userid/$id.json?auth=$auth';  
    try {
      final response = await http.put(
        url,
        body: json.encode(
          favourite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}










