import 'package:flutter/material.dart';
import 'package:untitled/main.dart';

class history extends StatefulWidget {
  const history({Key? key}) : super(key: key);

  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(title: Text("HisTory"), centerTitle: true),
        body: Column(
          children: [
            Container(
              child: Stack(
                children: [
                  Positioned(
                    child: Image.asset("assets/images/score-icon-38589.png",
                        height: 180),
                  ),
                  Positioned(
                    left: 92,
                    top: 20,
                    child: Text("1"),
                  ),
                  Positioned(
                    left: 150,
                    top: 60,
                    child: Text("3"),
                  ),
                  Positioned(
                    left: 25,
                    top: 45,
                    child: Text("2"),
                  ),
                ],
              ),
            ),
            Container(
              height: _height * 0.65,
              child: ListView.builder(
                itemCount: total_score.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    child: ListTile(
                        leading: CircleAvatar(
                            radius: 25, child: Text("${index + 1}")),
                        title: Text("Score : ${total_score[index]}"),
                        trailing: Text("${time[index]}".split(".")[0])),
                  );
                },
              ),
            )
          ],
        ));
  }
}
