import 'package:flutter/material.dart';
//import 'package:http/http.dart';
import "./cart.dart";
import 'package:provider/provider.dart';
import './cartitem.dart';
import './orders.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var loading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartAdd>(context);

    return Scaffold(
        appBar: AppBar(
            title: Text("Cart Items"),
            centerTitle: true,
            backgroundColor: Colors.black),
        body: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(10),
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: loading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Total",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                //Spacer(),
                                Chip(
                                    label:
                                        Text("${cart.totalcost.toString()}")),
                              ],
                            ),
                            RaisedButton(
                                onPressed: cart.totalcost <= 0
                                    ? null
                                    : () {
                                        setState(() {
                                          loading = true;
                                        });
                                        Provider.of<Orders>(context,
                                                listen: false)
                                            .addOrder(
                                                cart.items.values.toList(),
                                                cart.totalcost)
                                            .then((response) {
                                          
                                          setState(() {
                                            loading = false;
                                          });
                                          cart.clear();
                                        });

                                      },
                                color: Colors.black,
                                child: Text(
                                  "ORDER NOW",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                )),
                          ],
                        )),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: ((ctx, i) => CartItem(
                    cart.items.values.toList()[i].id,
                    cart.items.values.toList()[i].prod,
                    cart.items.values.toList()[i].quantity,
                    cart.items.values.toList()[i].price,

                )),
              ),
            ),
          ],
        ));
  }
}
