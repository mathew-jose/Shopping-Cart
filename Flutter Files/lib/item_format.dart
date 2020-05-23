import 'package:flutter/material.dart';
import 'package:shopping_cart/item_screen.dart';
import './item_structure.dart';
import 'package:provider/provider.dart';
import './cart.dart';
import './auth.dart';




class ItemList extends StatefulWidget {
  final Product product;
  ItemList(this.product);
  //@override
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  Widget build(BuildContext context) {
  final scaffold=Scaffold.of(context);
  final auth =Provider.of<Auth>(context,listen: false);
  //  final product = Provider.of<Product>(context,listen: false);
  final cart = Provider.of<CartAdd>(context, listen: false);
final produce=widget.product;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
          child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => ProductScreen(produce),
            ),
          );
        },
        
        child: Hero(
          tag:widget.product.id,
                child: GridTile(
                   child: FadeInImage(placeholder: AssetImage('assets/images/product-placeholder.png'),image:NetworkImage(widget.product.imageUrl,) ,fit:BoxFit.cover,),
            footer: GridTileBar(
              
            leading: IconButton(
                  icon: Icon(
                    widget.product.favourite ? Icons.favorite : Icons.favorite_border,
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                  widget.product.togglefavourite(
                      widget.product.id,
                      auth.gettoken,
                     auth.id,
                      
                   );
                    setState(() {
                      
                    });
                  },
                ),
          

             
              

              title: Text(
                widget.product.title,
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.black54,
            trailing: IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    cart.addItem(widget.product.id, widget.product.title, widget.product.price);
                   scaffold.hideCurrentSnackBar();
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text("Added TO The Cart!"),
                        duration: Duration(seconds: 2),
                        action: SnackBarAction(label:"UNDO", onPressed: (){
                          cart.removeItem(widget.product.id);
                        },),

                      ),

                    );
              
                  }),  
            
            ),
          ),
        ),
      ),
    );
  }
}
