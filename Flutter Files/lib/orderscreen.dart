import 'package:flutter/material.dart';
import 'package:shopping_cart/drawer.dart';
import 'package:shopping_cart/orders.dart';
import 'package:provider/provider.dart';
import "./orderlist.dart";

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var isin=true;
  var loading=false;
    @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isin) {
      setState(() {
        loading=true;
      });
     Provider.of<Orders>(context).fetchdata().then((response) {

       setState(() {
         loading=false;

       });
     });
 
    }
    isin = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final order=Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title:Text("Your Orders"),centerTitle:true,backgroundColor: Colors.black,),
      drawer: MainDrawer(),
      body:loading ?  Center(child: CircularProgressIndicator(),):ListView.builder(itemCount: order.items.length,itemBuilder:((ctx,i)=>OrderList(order.items[i]))),
    );

  }
}