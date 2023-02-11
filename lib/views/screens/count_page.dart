import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/providers/CountProvider.dart';
import 'package:state_management/providers/ThemeProvider.dart';

class count_page extends StatefulWidget {
  const count_page({Key? key}) : super(key: key);

  @override
  State<count_page> createState() => _count_pageState();
}

class _count_pageState extends State<count_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
        actions: [
          Switch(
              value: Provider.of<ThemeProvider>(context).isdrk,
              onChanged: (val) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .changeTheme();
              })
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              onPressed: () {
                Provider.of<CounterProvide>(context, listen: false).increment();
              },
              child: Icon(Icons.add)),
          SizedBox(width: 20),
          FloatingActionButton(
              onPressed: () {
                Provider.of<CounterProvide>(context, listen: false).decrement();
              },
              child: Icon(Icons.remove)),
        ],
      ),
      body: Center(
        child: Text(
          "${Provider.of<CounterProvide>(context).counter}",
          style: TextStyle(fontSize: 60),
        ),
      ),
    );
  }
}
