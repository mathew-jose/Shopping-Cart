import 'package:flutter/material.dart';
import './item_structure.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items;
  /* = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  
*/
  final String auth;
  final String userid;
  Products(this.auth, this._items, this.userid);
  var fav = false;
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favourite {
    return _items.where((tx) => tx.favourite).toList();
  }

  Product findbyID(String id) {
    return _items.firstWhere((tx) => tx.id == id);
  }

  Future<void> additem(Product product) {
    final url =
        'https://meals-app-1a5e5.firebaseio.com/products.json?auth=$auth';
    return http
        .post(
      url,
      body: jsonEncode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'creatorId':userid,

      }),
    )
        .then((response) {
      final newprod = Product(
          id: jsonDecode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          
          );

      _items.add(newprod);

      //  print(newprod.id);
      //  print(newprod.price);
      // print(newprod.title);
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  Future<void> updateitem(String id, Product item) async {
    var index = _items.indexWhere((tx) => tx.id == id);

    try {
      final url =
          'https://meals-app-1a5e5.firebaseio.com/products/$id.json?auth=$auth';
      await http.patch(
        url,
        body: jsonEncode({
          'title': item.title,
          'description': item.description,
          'price': item.price,
          'imageUrl': item.imageUrl,

        }),
      );
    } catch (error) {
      print(error);
      throw error;
    }
    _items[index] = item;

    notifyListeners();
  }

  Future<void> fetchdata([bool filter=false]) {
    var responsefav;
    final url =
        filter ? 'https://meals-app-1a5e5.firebaseio.com/products.json?auth=$auth'
        :'https://meals-app-1a5e5.firebaseio.com/products.json?auth=$auth&orderBy="creatorId"&equalTo="$userid"';
    return http.get(url).then((response) {
      final extract = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> data = [];
      if (extract == null) return;
      final urlfav =
          'https://meals-app-1a5e5.firebaseio.com/UserFavourites/$userid.json?auth=$auth';

     http.get(urlfav).then((favres) {
       responsefav = json.decode(favres.body);
      extract.forEach((ide, idvalue) {
        data.add(Product(
          id: ide,
          title: idvalue['title'],
          description: idvalue['description'],
          price: idvalue['price'],
          imageUrl: idvalue['imageUrl'],
          favourite: responsefav ==null ? false : responsefav[ide] ?? false,
        ));        
      });
      _items = data;
      notifyListeners();
     });



    }).catchError((error) {
      throw error;
    });
  }

  void deleteitem(String id) {
    final url =
        'https://meals-app-1a5e5.firebaseio.com/products/$id.json?auth=$auth';
    final index = _items.indexWhere((tx) => tx.id == id);
    var prod = _items[index];
    _items.removeAt(index);
    notifyListeners();

    http.delete(url).then((response) {
      if (response.statusCode >= 400) {
        throw HttpExceptions('Could Not Delete Element');
      }
      prod = null;
    }).catchError((error) {
      _items.insert(index, prod);
      notifyListeners();
    });

    _items.removeAt(index);
    notifyListeners();
  }
}
