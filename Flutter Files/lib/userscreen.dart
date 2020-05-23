import 'package:flutter/material.dart';
import 'package:shopping_cart/drawer.dart';
import 'package:shopping_cart/edit_item.dart';
import './product_provider.dart';
import 'package:provider/provider.dart';
import './useritem.dart';

class UserScreen extends StatelessWidget {
  Future <void> refresh(BuildContext context) async
  {
    await Provider.of<Products>(context).fetchdata();

  } 
  @override

  Widget build(BuildContext context) {
    final order = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> EditScreen("")));
          })
        ],
        backgroundColor: Colors.black,
      ),
      
      drawer: MainDrawer(),
      body: RefreshIndicator(
              onRefresh: ()=>refresh(context),
              child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
              itemCount: order.items.length,
              
              itemBuilder: ((ctx, i) => UserItem(order.items[i]))),
        ),
      ),
    );
  }
}
