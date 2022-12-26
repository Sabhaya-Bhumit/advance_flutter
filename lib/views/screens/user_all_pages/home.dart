import 'dart:convert';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_service_app/global.dart';
import 'package:home_service_app/helper/firebase_auth_helper.dart';
import 'package:home_service_app/helper/firestore_helper.dart';
import 'package:home_service_app/views/componenents/myDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

bool bhumit = false;
CarouselController carouselController = CarouselController();
int initvalue = 0;

class _homeState extends State<home> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.inactive:
        {
          print("App Is Inncative");
          break;
        }
      case AppLifecycleState.paused:
        {
          print("App Is Paused");
          break;
        }
      case AppLifecycleState.resumed:
        {
          print("App is resumed");
          break;
        }
      case AppLifecycleState.detached:
        {
          print("App is Terminates");
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _widht = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Center(
                  child: Text("You Have Exit"),
                ),
                content: Text("Welcome Back"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text("Yes")),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text("No")),
                ],
              )),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home page"),
          actions: [
            IconButton(
                onPressed: () async {
                  FirebaseAuthHelper.firebaseAuthHelper.singOutUser();
                  global.remember = false;
                  SharedPreferences pres =
                      await SharedPreferences.getInstance();
                  pres.setBool('remember', global.remember);

                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('login_page', (route) => false);
                },
                icon: Icon(Icons.power_settings_new_outlined))
          ],
        ),
        drawer: myDrawer(),
        body: (bhumit)
            ? StreamBuilder(
                stream: FireStoreHelper.fireStoreHelper
                    .fecthchAllData(name: "service_data"),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text("Error ${snapshot.error}"));
                  } else if (snapshot.hasData) {
                    QuerySnapshot? querySnapshort = snapshot.data;

                    List<QueryDocumentSnapshot> allDocs = querySnapshort!.docs;
                    List<Map<String, dynamic>> allData = [];
                    List icons = [];
                    List images = [];
                    for (int i = 0; i < allDocs.length; i++) {
                      allData.add(allDocs[i].data() as Map<String, dynamic>);
                      Uint8List iconU = base64.decode(allData[i]['icon']);
                      icons.add(iconU);
                      Uint8List imageU = base64.decode(allData[i]['images']);
                      images.add(imageU);
                    }
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          CarouselSlider(
                              carouselController: carouselController,
                              items: [
                                Image.memory(icons[0]),
                                Image.memory(icons[1]),
                                Image.memory(icons[2]),
                                Image.memory(icons[3]),
                              ],
                              options: CarouselOptions(
                                  height: _height * 0.3,
                                  autoPlay: true,
                                  aspectRatio: 0.8,
                                  enlargeCenterPage: true,
                                  // initialPage: initvalue,
                                  // onPageChanged: (val, _) {
                                  //   setState(() {
                                  //     // initvalue = val;
                                  //   });
                                  // },
                                  autoPlayCurve: Curves.decelerate)),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              height: _height * 0.8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 20);
                                },
                                itemCount: allDocs.length,
                                itemBuilder: (context, i) {
                                  return Card(
                                    elevation: 15,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            'worker_detail',
                                            arguments: allData[i]
                                                ['category_name']);
                                      },
                                      child: Container(
                                        height: _height,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Column(
                                          children: [
                                            Text(
                                              "${allData[i]['category_name']}",
                                              style: TextStyle(fontSize: 30),
                                            ),
                                            Text("icon  👇🏻"),
                                            Image.memory(icons[i], height: 150),
                                            SizedBox(height: 20),
                                            Text("image  👇🏻"),
                                            Image.memory(images[i],
                                                height: 150),
                                            Text("${allData[i]['detail']}"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )
            : null,
      ),
    );
  }
}
