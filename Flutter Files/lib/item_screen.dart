import "package:flutter/material.dart";
import "./item_structure.dart";
import "package:provider/provider.dart";
import './product_provider.dart';
import 'main.dart';

class ProductScreen extends StatelessWidget {
  final Product item;
  ProductScreen(this.item);
  @override

  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context, listen: false).items.firstWhere((prod) => prod.id == item.id);

    return Scaffold(
    
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading:IconButton(icon: Icon(Icons.arrow_back),color: Colors.black, onPressed: (){
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => MyHomePage()),
  (Route<dynamic> route) => false,
);
            }),

            expandedHeight: 300,
            pinned: true,
            automaticallyImplyLeading: false,
            
           
              
            flexibleSpace: FlexibleSpaceBar(title:Text(products.title,style: TextStyle(color:Colors.black),),
            background: Hero(
              tag: item.id,
              child: Container(
                height:300,
                width:double.infinity,
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ),
          ),
          SliverList(
            
            delegate:SliverChildListDelegate([
 Column(
   children: <Widget>[
     Padding(
       padding: const EdgeInsets.all(10.0),
       child: Text(
                    "\$ " + "${item.price}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
                    textAlign: TextAlign.left,
                  ),
     ),
            Text(
              "\n\n\n"+item.description,
              style: TextStyle(fontSize: 15),
                            textAlign: TextAlign.center,

            ),
        SizedBox(height: 1000,)

   ],
 ),
  
            ]),
          ),
        ],
             
      ),
    );
  }
}
