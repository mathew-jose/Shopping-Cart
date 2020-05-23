import 'package:flutter/material.dart';
import 'package:shopping_cart/userscreen.dart';
import './main.dart';
import "./orderscreen.dart";
import "package:provider/provider.dart";
import './auth.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        Container(
          height: 120,
          width: double.infinity,
          padding: EdgeInsets.all(10),
          alignment: Alignment.centerLeft,
          color: Colors.blue,
          child: Text(
            "Hello There",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        ListTile(
            leading: Icon(Icons.shop, size: 25),
            title: Text("Available Items",
                style: TextStyle(fontSize: 15, color: Colors.red)),
            onTap: () {
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => MyHomePage()),
  (Route<dynamic> route) => false,
);
            }),
        ListTile(
            leading: Icon(Icons.payment, size: 25),
            title: Text("Orders",
                style: TextStyle(fontSize: 15, color: Colors.red)),
            onTap: () {
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => OrderScreen()),
  (Route<dynamic> route) => false,
);
            }),
                    ListTile(
            leading: Icon(Icons.payment, size: 25),
            title: Text("Your Items",
                style: TextStyle(fontSize: 15, color: Colors.red)),
            onTap: () {
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => UserScreen()),
  (Route<dynamic> route) => false,
);
            }),
            
        ListTile(
            leading: Icon(Icons.exit_to_app, size: 25),
            title: Text("Logout",
                style: TextStyle(fontSize: 15, color: Colors.red)),
            onTap: () {
          Provider.of<Auth>(context,listen:false).logout();
            }),


      ],
    ));
  }
}
