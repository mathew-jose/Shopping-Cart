import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/userscreen.dart';
import 'item_structure.dart';
import './product_provider.dart';

class EditScreen extends StatefulWidget {
  final String id;
  EditScreen(this.id);
  @override
  _EditScreenState createState() => _EditScreenState(id);
}

class _EditScreenState extends State<EditScreen> {
  final String ide;
  _EditScreenState(this.ide);

  final quantityfocus = FocusNode();
  final descfocus = FocusNode();
  final imagefocus = FocusNode();
  final imagecontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();

  var item =
      Product(id: "", title: "", description: "", price: 0, imageUrl: "");
  var loading = false;
  @override
  void initState() {
    imagefocus.addListener(updateurl);
    super.initState();
  }

  @override
  void dispose() {
    imagefocus.removeListener(updateurl);
    quantityfocus.dispose();
    imagecontroller.dispose();
    descfocus.dispose();
    super.dispose();
  }

  var isin = true;
  var initvalues = {};
  @override
  void didChangeDependencies() {
    if (isin) {
      if (ide != "") {
        final product = Provider.of<Products>(context).findbyID(ide);
        initvalues = {
          "id": product.id,
          "title": product.title,
          "description": product.description,
          "price": product.price.toString(),
          "imageUrl": "",
        };
        imagecontroller.text = product.imageUrl;
      }
    }

    isin = false;
    super.didChangeDependencies();
  }

  void updateurl() {
    if (!imagefocus.hasFocus) {
      if ((!imagecontroller.text.startsWith("http") &&
          !imagecontroller.text.startsWith("https"))) {
        return;
      }

      setState(() {});
    }
  }

  void saveform() {
    final valid = formkey.currentState.validate();
    if (!valid) {
      return;
    }
    formkey.currentState.save();
    setState(() {
      loading = true;
    });

    if (ide == "") {
      Provider.of<Products>(context, listen: false)
          .additem(item)
          .catchError((error) {})
          .then((_) {
        setState(() {
          loading = false;
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => UserScreen()),
          (Route<dynamic> route) => false,
        );
      });
    } else {
      Provider.of<Products>(context, listen: false).updateitem(ide, item).then((_){
 setState(() {
        loading = false;
      });

      Navigator.of(context).pop();
    
    
      });
  } 
    //  Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Items'),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save_alt), onPressed: saveform),
        ],
      ),
      body: loading
          ? Center(
              child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.white,
                  child: CircularProgressIndicator(strokeWidth: 10,)),
            )
          : Form(
              key: formkey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Title ",
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(quantityfocus);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Provide a Value';
                        }
                        return null;
                      },
                      initialValue: initvalues['title'],
                      onSaved: (value) {
                        item = Product(
                          id: ide,
                          title: value,
                          description: item.description,
                          price: item.price,
                          imageUrl: item.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Price ",
                      ),
                      initialValue: initvalues['price'],
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: quantityfocus,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(descfocus);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Provide a Value';
                        }
                        if (double.tryParse(value) == null)
                          return 'Enter a Number';
                        if (double.parse(value) <= 0)
                          return 'Enter a Positive Number';
                        else
                          return null;
                      },
                      onSaved: (value) {
                        item = Product(
                            id: ide,
                            title: item.title,
                            description: item.description,
                            price: double.parse(value),
                            imageUrl: item.imageUrl);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                              child: imagecontroller.text.isEmpty
                                  ? Text("Enter A URL")
                                  : FittedBox(
                                      child:
                                          Image.network(imagecontroller.text),
                                      fit: BoxFit.cover,
                                    )),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: "Image URL"),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: imagefocus,
                            controller: imagecontroller,
                            onFieldSubmitted: (_) {
                              saveform();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Provide a Value';
                              }
                              if (!value.startsWith("http") &&
                                  !value.startsWith("https")) {
                                return 'Please Provide a Correct URL';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              item = Product(
                                  id: ide,
                                  title: item.title,
                                  description: item.description,
                                  price: item.price,
                                  imageUrl: value);
                            },
                          ),
                        ),
                      
                      ],


                    ),
                     TextFormField(
                      decoration: InputDecoration(
                        labelText: "Description ",
                      ),
                      initialValue: initvalues['description'],
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      focusNode: descfocus,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(imagefocus);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Provide a Value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        item = Product(
                            id: ide,
                            title: item.title,
                            description: value,
                            price: item.price,
                            imageUrl: item.imageUrl);
                      },
                    ),
                   
                  ],
                ),
              ),
            ),
    );
  }
}
