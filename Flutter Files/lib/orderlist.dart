import 'package:flutter/material.dart';
import 'package:shopping_cart/orders.dart';
import "package:intl/intl.dart";

class OrderList extends StatefulWidget {
  final OrderItem order;
  OrderList(this.order);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  var expand = false;
  double min (double a,double b)
  {
    if(a<b)
    return a;
    else
    return b;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration:Duration(milliseconds: 300),
      height: expand ? min(widget.order.items.length * 20.0 + 110, 1000) : 95,
          child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.all(10),
            title: Text(
              '${widget.order.amount.toString()}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle:
                Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date)),
            trailing: IconButton(
              icon: Icon(expand ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  expand = !expand;
                });
              },
            ),
          ),
                  
              AnimatedContainer(
                duration: Duration(milliseconds:300),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                height: expand ? min(widget.order.items.length * 20.0 + 10, 100) : 0,
                child: ListView(
                  children: widget.order.items
                      .map(
                       
                        (prod) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  prod.prod,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${prod.quantity}x \$ ${prod.price}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                      )
                      .toList(),
                ),
              )
        ],
      ),
    );
  }
}
