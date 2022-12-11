import 'dart:convert';
import 'dart:math';

import 'package:demo/global.dart';
import 'package:demo/helpers/animal_db.dart';
import 'package:demo/helpers/image_api.dart';
import 'package:demo/modal/animal_modal.dart';
import 'package:demo/modal/image_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class splace_Screen extends StatefulWidget {
  const splace_Screen({Key? key}) : super(key: key);

  @override
  State<splace_Screen> createState() => _splace_ScreenState();
}

class _splace_ScreenState extends State<splace_Screen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animal();
    cal();
  }

  Random random = Random();
  int i = 0;
  animal() async {
    int i = random.nextInt(7);
    // global.Images = await Image_api.image_api
    //     .feach_Data(Animal_name: "${global.Animal_name[i]['name']}");
    String Jsondata =
        await rootBundle.loadString("assets/json_data/my_json_data.json");
    Map decodedData = jsonDecode(Jsondata);
    List data = decodedData["${global.Animal_name[i]['name']}"];
    print(data.length);
    Animal_db.animal_db.deleteAllData();
    data.forEach((e) async {
// print(e);
      Animal_Modal a1 = Animal_Modal(
          name: e['name'],
          color: e['characteristics']['color'],
          average_litter_size: e['characteristics']['average_litter_size'],
          loction: e['locations'][0],
          skin_type: e['characteristics']['skin_type'],
          lifespan: e['characteristics']['lifespan'],
          type: e['characteristics']['type'],
          diet: e['characteristics']['diet']);

      print(a1.name);
// print(a1.color);
// print(a1.loction);

      int? res = await Animal_db.animal_db.inserRecode(data: a1);
      print(res);
    });
  }

  cal() async {
    await Future.delayed(Duration(seconds: 10), () {
      Navigator.of(context).pushReplacementNamed('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    int i = random.nextInt(7);
    return Scaffold(
      body: FutureBuilder(
        future: Image_api.image_api
            .feach_Data(Animal_name: "${global.Animal_name[i]['name']}"),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error is = ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            List<Image_Modal>? list = snapshot.data;
            return Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  "${list![0].Image}",
                  height: double.infinity,
                  fit: BoxFit.fitHeight,
                ),
                Container(
                  alignment: Alignment.center,
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.grey.withOpacity(0.5),
                  ])),
                  child: FutureBuilder(
                    future: Animal_db.animal_db.fetchAllRecode(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error is = ${snapshot.error}"),
                        );
                      } else if (snapshot.hasData) {
                        global.Animal_Detail = snapshot.data;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(height: 5),
                            Text("Name : ${global.Animal_Detail![i].name}",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text(
                                "Loction : ${global.Animal_Detail![i].loction}",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text("Color : ${global.Animal_Detail![i].color}",
                                style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text(
                                "Skin Type : ${global.Animal_Detail![i].skin_type}",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text(
                                "Lifespan : ${global.Animal_Detail![i].lifespan}",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text(
                                "Average Litter Size : ${global.Animal_Detail![i].average_litter_size}",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text("Diet : ${global.Animal_Detail![i].diet}",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text("Type : ${global.Animal_Detail![i].type}",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            SizedBox(height: 5),
                            CircularProgressIndicator(),
                          ],
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                )
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
