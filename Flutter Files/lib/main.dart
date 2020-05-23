import 'package:flutter/material.dart';
import 'package:shopping_cart/cart.dart';
import 'package:shopping_cart/drawer.dart';
import 'package:shopping_cart/orders.dart';
import 'package:shopping_cart/product_overview.dart';
import 'package:provider/provider.dart';
import './product_provider.dart';
import './badge.dart';
import './cart.dart';
import './cartscreen.dart';
import './orders.dart';
import './auth.dart';
import './auth_screen.dart';

enum Filters {
  All,

  Favourites,
}

var favs=false;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      
        ChangeNotifierProxyProvider<Auth,Products>(
          create: (_) => Products('', [],''),
          update: (ctx,auth,prevproducts) => Products(auth.token , prevproducts == null ? [] : prevproducts.items,auth.userid),
       
        ),
        ChangeNotifierProxyProvider<Auth,CartAdd>(
          create: (_) => CartAdd('', {}),
          update: (ctx,auth,prevproducts) => CartAdd(auth.token , prevproducts == null ? {} : prevproducts.items),
       
        ),
        ChangeNotifierProxyProvider<Auth,Orders>(
          create: (_) => Orders('', [],""),
          update: (ctx,auth,prevproducts) => Orders(auth.token , prevproducts == null ? [] : prevproducts.items,auth.userid),
       
        ),
      ],
      child:Consumer<Auth>(builder: (ctx,auth,_)=>MaterialApp(
        home: auth.isAuth ? MyHomePage() :    FutureBuilder(
          future: auth.tryauto(),

          builder: (ctx,authresult)=> authresult.connectionState== ConnectionState.waiting  ?   CircularProgressIndicator()     :  AuthScreen(),)
      
        //    theme: ThemeData.dark(),
      ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          " Shopping Cart",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (Filters a) {
                print(a);
               
                  if (a == Filters.All)
                    favs = false;
                  else if (a == Filters.Favourites) 
                  favs = true;
                
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(child: Text("All Items"), value: Filters.All),
                    PopupMenuItem(
                        child: Text("Favourites"), value: Filters.Favourites),
                  ]),
          Consumer<CartAdd>(
            builder: (_, cart, ch) =>
                Badge(child: ch, value: cart.cartsize.toString()),
            child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => CartScreen(),
                    ),
                  );
                }),
          ),
        ],
      ),
      drawer: MainDrawer(),
      body:FutureBuilder(future:Provider.of<Products>(context,listen: false).fetchdata() ,builder: (ctx,snap){
        if(snap.connectionState==ConnectionState.waiting)
       return  Center(child: CircularProgressIndicator(),);
       else
       return Consumer<Products>(builder: (ctx,data,child)=> ProductOverview(favs));


      })  //loading? Center(child: CircularProgressIndicator(),) : ProductOverview(favs),
    );
  }
}
