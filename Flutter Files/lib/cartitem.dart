import 'package:flutter/material.dart';
import './cart.dart';
import "package:provider/provider.dart";

class CartItem extends StatelessWidget {
  final String id;
  final String prod;
  final int quantity;
  final double price;
  
  CartItem(this.id,this.prod,this.quantity,this.price);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          
          builder: ((ctx) => AlertDialog(
                title: Text("Confirm Deletion"),
                content: Text("Are you sure you want to delete?"),
actions: <Widget>[

  FlatButton(onPressed:(){
    Navigator.of(ctx).pop(false);
  }, child: Text("CANCEL")),
  RaisedButton(onPressed:(){
    Navigator.of(ctx).pop(true);


  }, child: Text("CONFIRM"))
],
          )
              ),
      
              
              
        );
      },
      onDismissed: (DismissDirection direction) {
        Provider.of<CartAdd>(context, listen: false).removeItem(id);

      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child: Text("$price"),
              maxRadius: 30,
              minRadius: 30,
            ),
            title: Text(prod),
            subtitle: Text('${price *quantity}'),
            trailing: Text("$quantity x"),
          ),
        ),
      ),
    );
  }
}
