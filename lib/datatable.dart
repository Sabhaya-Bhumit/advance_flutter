import 'package:flutter/material.dart';

class datatable extends StatefulWidget {
  const datatable({Key? key}) : super(key: key);

  @override
  State<datatable> createState() => _datatableState();
}

class _datatableState extends State<datatable> {
  @override
  Widget build(BuildContext context) {
    dynamic res = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
          title:
              (res == 0) ? Text("API In DataTable") : Text("Json In DataTable"),
          centerTitle: true),
      body: Container(
        child: IndexedStack(
          index: 0,
          children: [],
        ),
        alignment: Alignment.center,
      ),
    );
  }
}
