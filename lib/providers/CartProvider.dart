import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../modals/ProductProvider.dart';

class CartProvider extends ChangeNotifier {
  List<Product> allcart = [];

  get allProduct {
    int totalcount = 0;
    allcart.forEach((element) {
      totalcount += element.count;
    });
    return totalcount;
  }

  get totalPrice {
    int price = 0;
    for (var prices in allcart) {
      price += (prices.price * prices.count);
    }
    return price;
  }

  void Countpluse({required Product product}) {
    product.count++;
    notifyListeners();
  }

  void CountdecrementAndRemove({required Product product}) {
    if (product.count > 1) {
      product.count--;

      notifyListeners();
    } else {
      product.count--;
      allcart.remove(product);

      notifyListeners();
    }
  }

  void addToCart({required Product product}) {
    if (product.count >= 1) {
      print(product.count);
      print("same");
    } else {
      print("add cart");

      product.count++;
      allcart.add(product);

      notifyListeners();
    }
  }
}
