import 'package:demo/global.dart';
import 'package:demo/helpers/animal_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class detail_page extends StatefulWidget {
  const detail_page({Key? key}) : super(key: key);

  @override
  State<detail_page> createState() => _detail_pageState();
}

int val = 0;

// animal() async {
//   global.Images = await Image_api.image_api
//       .feach_Data(Animal_name: "${global.Animal_name[global.inint]['name']}");
//   String Jsondata =
//       await rootBundle.loadString("assets/json_data/my_json_data.json");
//   Map decodedData = jsonDecode(Jsondata);
//   List data = decodedData["${global.Animal_name[global.inint]['name']}"];
//   print(data.length);
//   Animal_db.animal_db.deleteAllData();
//   data.forEach((e) async {
// // print(e);
//     Animal_Modal a1 = Animal_Modal(
//         name: e['name'],
//         color: e['characteristics']['color'],
//         average_litter_size: e['characteristics']['average_litter_size'],
//         loction: e['locations'][0],
//         skin_type: e['characteristics']['skin_type'],
//         lifespan: e['characteristics']['lifespan'],
//         type: e['characteristics']['type'],
//         diet: e['characteristics']['diet']);
//
//     print(a1.name);
// // print(a1.color);
// // print(a1.loction);
//
//     int? res = await Animal_db.animal_db.inserRecode(data: a1);
//     print(res);
//   });
// }

class _detail_pageState extends State<detail_page> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    val = 0;
  }

  @override
  Widget build(BuildContext context) {
    dynamic res = ModalRoute.of(context)!.settings.arguments;
    animal() {}
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text("${res['name']}".toUpperCase()),
          centerTitle: true),
      body: FutureBuilder(
        future: Animal_db.animal_db.fetchAllRecode(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("error is =${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            global.Animal_Detail = snapshot.data;
            print(global.Animal_Detail);
            return ListView.builder(
              itemCount: global.Animal_Detail!.length,
              itemBuilder: (context, i) {
                return Card(
                    elevation: 10,
                    margin: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            global.imageCount = i + val;
                            Navigator.of(context).pushNamed('image_detail_page',
                                arguments: global.Animal_Detail![i]);
                          },
                          child: Container(
                              height: 500,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10)),
                                    child: Image.network(
                                      "${global.Images![i + val].Image}",
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 500,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                      Colors.white.withOpacity(0.5),
                                      Colors.grey.withOpacity(0.5),
                                    ])),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                            "Name : ${global.Animal_Detail![i].name}",
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
                                        Text(
                                            "Color : ${global.Animal_Detail![i].color}",
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
                                        Text(
                                            "Diet : ${global.Animal_Detail![i].diet}",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                        Text(
                                            "Type : ${global.Animal_Detail![i].type}",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                        ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                            child: Container(
                                              height: 50,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          val++;
                                                        });
                                                      },
                                                      child: isRow(
                                                          image:
                                                              "assets/images/stcak.png")),
                                                  InkWell(
                                                      onTap: () {
                                                        Clipboard.setData(
                                                            ClipboardData(
                                                                text:
                                                                    "Name : ${global.Animal_Detail![i].name}"));
                                                      },
                                                      child: isRow(
                                                          image:
                                                              "assets/images/copy.png")),
                                                  InkWell(
                                                      onTap: () async {},
                                                      child: isRow(
                                                          image:
                                                              "assets/images/929539.png")),
                                                  InkWell(
                                                      onTap: () async {
                                                        //
                                                      },
                                                      child: isRow(
                                                          image:
                                                              "assets/images/downlod.png")),
                                                  InkWell(
                                                      onTap: () {},
                                                      child: isRow(
                                                          image:
                                                              "assets/images/star.png"))
                                                ],
                                              ),
                                            ))
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        )
                      ],
                    ));
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget isRow({required String image}) {
    return Image.asset("$image", width: 40);
  }
}
