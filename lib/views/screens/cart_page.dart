import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modals/ProductProvider.dart';
import '../../providers/CartProvider.dart';
import '../../providers/ThemeProvider.dart';

class cart_page extends StatefulWidget {
  const cart_page({Key? key}) : super(key: key);

  @override
  State<cart_page> createState() => _cart_pageState();
}

class _cart_pageState extends State<cart_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart"), actions: [
        Switch(
            value: Provider.of<ThemeProvider>(context).isdrk,
            onChanged: (val) {
              Provider.of<ThemeProvider>(context, listen: false).changeTheme();
            })
      ]),
      body: Column(
        children: [
          Expanded(
              child: Column(
            children: [
              Text(
                  "total Product : ${Provider.of<CartProvider>(context).allProduct}"),
              Text(
                  "total price : ${Provider.of<CartProvider>(context).totalPrice}"),
            ],
          )),
          Expanded(
              flex: 12,
              child: ListView.builder(
                  itemCount: Provider.of<CartProvider>(context).allcart.length,
                  itemBuilder: (contecxt, i) {
                    Product product =
                        Provider.of<CartProvider>(context).allcart[i];
                    return Card(
                      elevation: 5,
                      child: ListTile(
                          title: Text("${product.name}"),
                          subtitle: Text("${product.price}"),
                          leading: Text("${i + 1}"),
                          trailing: Container(
                            width: 120,
                            color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .Countpluse(product: product);
                                    },
                                    icon: Icon(Icons.add)),
                                Text("${product.count}"),
                                IconButton(
                                    onPressed: () {
                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .CountdecrementAndRemove(
                                              product: product);
                                    },
                                    icon: Icon(Icons.remove)),
                              ],
                            ),
                          )),
                    );
                  })),
        ],
      ),
    );
  }
}
