import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/histore.dart';

void main() async {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {'/': (context) => home(), 'history': (context) => history()},
    ),
  );
}

int give = 0;
int score = 0;
List<String> total_score = [];
List<String> time = [];

List _color = [
  Colors.green,
  Colors.yellow,
  Colors.deepOrangeAccent,
  Colors.brown,
  Colors.lightBlue,
  Color(0xff2b2d42),
  Color(0xff81b29a),
  Color(0xfffec89a),
  Color(0xffef476f),
  Color(0xff7371fc),
];
List value = [
  {
    "titale": 1,
    "value": 5,
    "move": false,
  },
  {
    "titale": 2,
    "value": 3,
    "move": false,
  },
  {
    "titale": 3,
    "value": 4,
    "move": false,
  },
  {
    "titale": 4,
    "value": 1,
    "move": false,
  },
  {
    "titale": 5,
    "value": 2,
    "move": false,
  },
  {
    "titale": 6,
    "value": 7,
    "move": false,
  },
  {
    "titale": 7,
    "value": 10,
    "move": false,
  },
  {
    "titale": 8,
    "value": 9,
    "move": false,
  },
  {
    "titale": 9,
    "value": 6,
    "move": false,
  },
  {
    "titale": 10,
    "value": 8,
    "move": false,
  },
];

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

pres() async {
  SharedPreferences pres = await SharedPreferences.getInstance();

  total_score = pres.getStringList('total_score') ?? [];
  time = pres.getStringList('time') ?? [];
}

class _homeState extends State<home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pres();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("You Score  :  $score        Game"),
        actions: [
          IconButton(
              onPressed: () async {
                setState(() {
                  Navigator.of(context).pushNamed('history');
                });
              },
              icon: Icon(Icons.history)),
          IconButton(
              onPressed: () {
                setState(() {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("You want to play again\n"),
                        elevation: 0,
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: Text("NO")),
                            SizedBox(width: 20),
                            ElevatedButton(
                                onPressed: () async {
                                  total_score.add(score.toString());
                                  time.add(DateTime.now().toString());
                                  value.forEach((element) {
                                    element['move'] = false;
                                  });
                                  setState(() {
                                    score = 0;
                                  });
                                  SharedPreferences pres =
                                      await SharedPreferences.getInstance();

                                  pres.setStringList(
                                      'total_score', total_score);
                                  pres.setStringList('time', time);
                                  Navigator.of(context).pop();
                                },
                                child: Text("Yes"))
                          ],
                        ),
                      );
                    },
                  );
                });
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: (give == 10)
          ? Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Game Over",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                  Text(
                    "\nYou Score : $score\n",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("You want to play again\n"),
                                  elevation: 0,
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton(
                                          onPressed: () {
                                            setState(() {
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: Text("NO")),
                                      SizedBox(width: 20),
                                      ElevatedButton(
                                          onPressed: () async {
                                            give = 0;
                                            total_score.add(score.toString());
                                            time.add(DateTime.now().toString());
                                            value.forEach((element) {
                                              element['move'] = false;
                                            });
                                            setState(() {
                                              score = 0;
                                            });
                                            SharedPreferences pres =
                                                await SharedPreferences
                                                    .getInstance();

                                            pres.setStringList(
                                                'total_score', total_score);
                                            pres.setStringList('time', time);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Yes"))
                                    ],
                                  ),
                                );
                              },
                            );
                          });
                        },
                        child: Text(
                          "Restart",
                          style: TextStyle(fontSize: 20),
                        )),
                  )
                ],
              ),
            )
          : Container(
              alignment: Alignment.center,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: _height * 0.89,
                          width: _width,
                          child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return Column(
                                children: [
                                  SizedBox(height: 10),
                                ],
                              );
                            },
                            itemCount: value.length,
                            itemBuilder: (context, index) {
                              return DragTarget(
                                onWillAccept: (data) {
                                  // print('data = $data');
                                  // print('index = $index');
                                  // print(
                                  //     'Value = ${value[int.parse('$data')]['move']}');
                                  return data == value[index]['titale'];
                                },
                                onAccept: (data) {
                                  setState(() {
                                    // print(
                                    //     "before = ${value[int.parse('$data')]['move']}");

                                    value.forEach((element) {
                                      if (element['value'] == data) {
                                        element['move'] = true;
                                      }
                                    });

                                    // value[int.parse('$data')]['move'] = true;
                                    // print(
                                    //     "After = ${value[int.parse('$data')]['move']}");
                                  });
                                },
                                builder:
                                    (context, candidateData, rejectedData) {
                                  return Container(
                                    height: 150,
                                    color: _color[index],
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${value[index]['titale']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 50,
                                          color: Colors.white),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return Column(
                        children: [
                          SizedBox(height: 10),
                        ],
                      );
                    },
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return (value[index]["move"])
                          ? Container()
                          : Draggable(
                              onDragCompleted: () {
                                setState(() {
                                  score = score + 5;
                                  give++;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Your points are increased by 5"),
                                          backgroundColor: Colors.green,
                                          behavior: SnackBarBehavior.floating,
                                          duration:
                                              Duration(milliseconds: 700)));
                                });
                              },
                              onDraggableCanceled: (velocity, offset) {
                                setState(() {
                                  (score > 0) ? score = score - 5 : score = 0;
                                  (score > 0)
                                      ? ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Your points are decreasing by 5"),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor: Colors.red,
                                              duration:
                                                  Duration(milliseconds: 700)))
                                      : ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text("Missing"),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor: Colors.red,
                                              duration:
                                                  Duration(milliseconds: 700)));
                                });
                              },
                              data: value[index]["value"],
                              childWhenDragging: Container(height: 150),
                              child: Container(
                                height: 150,
                                alignment: Alignment.center,
                                child: Text(
                                  "${value[index]["value"]}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50,
                                      color: _color[index]),
                                ),
                              ),
                              feedback: Container(
                                height: 150,
                                alignment: Alignment.center,
                                child: Text(
                                  "${value[index]["value"]}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50,
                                      color: _color[index],
                                      decoration: TextDecoration.none),
                                ),
                              ));
                    },
                  )),
                ],
              ),
            ),
    );
  }
}
