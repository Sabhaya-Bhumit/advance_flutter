import 'package:flutter/material.dart';
import 'package:get/get.dart';

class page2_page extends StatefulWidget {
  const page2_page({Key? key}) : super(key: key);

  @override
  State<page2_page> createState() => _page2_pageState();
}

class _page2_pageState extends State<page2_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Page2"), centerTitle: true),
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                Get.offAllNamed('/');
              },
              child: Text("Go To Home Page"))),
    );
  }
}
