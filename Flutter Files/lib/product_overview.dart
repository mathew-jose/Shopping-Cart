import 'package:flutter/material.dart';
import './item_format.dart';
import "./product_provider.dart";
import "package:provider/provider.dart";

class ProductOverview extends StatelessWidget {
  final bool favs;
  ProductOverview(this.favs);

  
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final item = favs ? productsData.favourite: productsData.items;
    return Scaffold(
        // appBar: AppBar(
        //   title: Text("Products ON Display"),
        //   centerTitle: true,
        // ),
        body: GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: item.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(   
      value:item[i],

      child: ItemList(item[i]),
      ),
    ),
    );
  }
}
