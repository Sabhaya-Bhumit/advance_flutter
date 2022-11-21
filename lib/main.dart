import 'package:flutter/material.dart';
import 'package:untitled/datatable.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(primary: Colors.green)),
      routes: {
        ''
            '/': (context) => home(),
        'datatable': (context) => datatable(),
      },
    ),
  );
}

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

List name = ["API IN DataTable", "Json In DataTable"];

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("DataTable"),
          centerTitle: true,
        ),
        body: Center(
            child: Container(
          child: ListView.builder(
            itemCount: name.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    Navigator.of(context)
                        .pushNamed('datatable', arguments: index);
                  });
                },
                child: Container(
                  height: 200,
                  margin: EdgeInsets.all(10),
                  color: Colors.green,
                  alignment: Alignment.center,
                  child: Text(
                    "${name[index]}",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
          alignment: Alignment.center,
        )));
  }
}
