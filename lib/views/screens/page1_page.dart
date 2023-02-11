import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_management_2/controllers/Count_Controller.dart';

class page1_page extends StatefulWidget {
  const page1_page({Key? key}) : super(key: key);

  @override
  State<page1_page> createState() => _page1_pageState();
}

class _page1_pageState extends State<page1_page> {
  @override
  Widget build(BuildContext context) {
    CounterController counterController = Get.find<CounterController>();
    return Scaffold(
      appBar: AppBar(title: Text("Page1"), centerTitle: true),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Get.toNamed('/page2');
              },
              child: Text("Go page2")),
          ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Go home")),
        ],
      )),
    );
  }
}
