import 'package:flutter/material.dart';
import "./cart.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<Cart> items;
  final DateTime date;
  OrderItem(this.id, this.amount, this.items, this.date);
}

class Orders with ChangeNotifier {
  List<OrderItem> items = [];
  List<OrderItem> get item {
    return [...items];
  }
String auth;
String userid;

Orders(this.auth,this.items,this.userid);


  Future<void> addOrder(List<Cart> products, double amount) {
    final url = 'https://meals-app-1a5e5.firebaseio.com/orders/$userid.json?auth=$auth';
    final timestamp = DateTime.now();
    return http
        .post(url,
            body: jsonEncode({
              'amount': amount,
              'time': timestamp.toIso8601String(),
              'products': products.map((tx) => {
                    "id": tx.id,
                    "title": tx.prod,
                    "price": tx.price,
                    "quantity": tx.quantity,
                    "orderBy": userid,

                  }).toList(),
            }))
        .then((response) {
      items.insert(
        0,
        OrderItem(json.decode(response.body)['name'], amount, products,
            DateTime.now()),
      );

      notifyListeners();
    }).catchError((onError){
print(onError);
throw onError;

    });
  }



 Future<void> fetchdata() async {

    final url = 'https://meals-app-1a5e5.firebaseio.com/orders/$userid.json?auth=$auth';
 
 final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
           orderId,
         orderData['amount'],
         
          (orderData['products'] as List<dynamic>)
              .map(
                (item) => Cart(
                      item['id'],
                     item['title'],
                     item['quantity'],
                       item['price'],
                    ),
              )
              .toList(),
             DateTime.parse(orderData['time']),

        ),
      );
    });
    items = loadedOrders.reversed.toList();
    notifyListeners();
  }
 
}
 
 
 /*   return http.get(url).then((response) {
      final List<OrderItem> data = [];

      final extract = json.decode(response.body) as Map<String, dynamic>;

      
      extract.forEach((ide, idvalue) {
      data.add(OrderItem(
        ide,

        idvalue['amount'],

       (idvalue['products'] as List<dynamic> ).map((tx){

Cart(tx['id'], tx['title'], tx['quantity'], tx['price']);

print(tx['id']);
print(tx);
}
       
       ).toList(), 

      DateTime.parse(idvalue["time"]),
      
      ) 
      );

      }

      );



      items=data;
      print(data[0].items);

notifyListeners();
      });

 //   }).catchError((error) {
  //    throw error;
   // });
  }

 }
*/




