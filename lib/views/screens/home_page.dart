import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/providers/CartProvider.dart';
import 'package:state_management/res/products.dart';

import '../../providers/ThemeProvider.dart';

class home_page extends StatefulWidget {
  const home_page({Key? key}) : super(key: key);

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page"), centerTitle: true, actions: [
        Center(
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('cart_page');
                },
                icon: Icon(Icons.shopping_cart))),
        Switch(
            value: Provider.of<ThemeProvider>(context).isdrk,
            onChanged: (val) {
              Provider.of<ThemeProvider>(context, listen: false).changeTheme();
            })
      ]),
      body: ListView.builder(
        itemCount: allProduct.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          return Card(
            elevation: 5,
            child: ListTile(
              title: Text("${allProduct[i].name}"),
              subtitle: Text("${allProduct[i].price}"),
              leading: Text("${i + 1}"),
              trailing: IconButton(
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .addToCart(product: allProduct[i]);
                  },
                  icon: Icon(Icons.add)),
            ),
          );
        },
      ),
    );
  }
}
