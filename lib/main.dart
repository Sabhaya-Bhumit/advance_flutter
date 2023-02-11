import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/providers/CartProvider.dart';
import 'package:state_management/providers/CountProvider.dart';
import 'package:state_management/providers/ThemeProvider.dart';
import 'package:state_management/views/screens/cart_page.dart';
import 'package:state_management/views/screens/count_page.dart';
import 'package:state_management/views/screens/home_page.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => CounterProvide()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      builder: (context, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: (Provider.of<ThemeProvider>(context).isdrk)
                  ? ThemeMode.dark
                  : ThemeMode.light,
              routes: {
                '/': (context) => home_page(),
                'count_page': (context) => count_page(),
                'cart_page': (context) => cart_page(),
              })));
}
