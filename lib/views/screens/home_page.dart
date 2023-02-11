import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_management_2/controllers/Count_Controller.dart';

class home_page extends StatefulWidget {
  const home_page({Key? key}) : super(key: key);

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  CounterController counterController = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page"), centerTitle: true, actions: [
        IconButton(
            onPressed: () {
              Get.changeTheme(
                  Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
            },
            icon: Icon(Icons.ac_unit))
      ]),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              onPressed: () {
                counterController.Increment();
              },
              child: Icon(Icons.add)),
          SizedBox(width: 20),
          FloatingActionButton(
              onPressed: () {
                counterController.decrement();
              },
              child: Icon(Icons.remove)),
        ],
      ),
      body: Center(
          child: GetBuilder<CounterController>(
              builder: (_) => Text(
                    "${counterController.counterModal.count}",
                    style: TextStyle(fontSize: 60),
                  ))),
    );
  }
}
