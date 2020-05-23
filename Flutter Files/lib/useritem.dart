
import 'package:flutter/material.dart';
import './item_structure.dart';
import './edit_item.dart';
import 'package:provider/provider.dart';
import 'product_provider.dart';


class UserItem extends StatelessWidget {
  final Product order;
  UserItem(this.order);
  @override
  Widget build(BuildContext context) {
      final scaffold=Scaffold.of(context);

    return ListTile(
      title: Text(order.title),
      leading: CircleAvatar(
        child: Image.network(order.imageUrl),
        backgroundColor: Colors.white,
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditScreen(order.id),
                    ),
                  );
                }),
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  
                  return showDialog(
                    context:context,

                      builder:(ctx)=> AlertDialog(
                      title: Text("Confirm Deletion"),
                      content: Text("Are you sure you want to delete?"),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.of(ctx).pop(false);
                            },
                            child: Text("CANCEL")),
                        RaisedButton(
                            onPressed: () async {
                              try {Provider.of<Products>(context,listen: false).deleteitem(order.id);}
                              catch(error){
                                
                                scaffold.showSnackBar(SnackBar(content:Text( 'Error Occured While Deleting'),),);
                              }
                              
                              Navigator.of(ctx).pop(true);
                            },
                            child: Text("CONFIRM"))
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
