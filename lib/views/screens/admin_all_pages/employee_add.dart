import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import '../../../helper/firestore_helper.dart';

class employee_add extends StatefulWidget {
  const employee_add({Key? key}) : super(key: key);

  @override
  State<employee_add> createState() => _employee_addState();
}

Future<Uint8List> testComporessList(Uint8List list) async {
  var result = await FlutterImageCompress.compressWithList(
    list, minHeight: 400,
    minWidth: 400,
    quality: 99,
    // rotate: 135,
  );
  print(list.length);
  print(result.length);
  return result;
}

class _employee_addState extends State<employee_add> {
  final GlobalKey<FormState> controller = GlobalKey<FormState>();

  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController pricecontroller = TextEditingController();
  final TextEditingController detailcontroller = TextEditingController();

  dynamic? initalValue;

  // String? icon;
  String image = "";

  // File? imagefile1;
  File? imagefile2;

  // String pathIcon = "";
  String pathImage = "";

  String error = "";
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    namecontroller.clear();
    pricecontroller.clear();
    detailcontroller.clear();
    image = "";
    imagefile2 = null;
    pathImage = "";
    error = "";
    initalValue = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Employee Add"), centerTitle: true),
      body: StreamBuilder(
          stream: FireStoreHelper.fireStoreHelper.fecthchCount(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error : ${snapshot.error}"));
            } else if (snapshot.hasData) {
              QuerySnapshot? querySnapshort = snapshot.data;

              List<QueryDocumentSnapshot> allDocs = querySnapshort!.docs;
              List<Map<String, dynamic>> allData = [];
              for (int i = 0; i < allDocs.length; i++) {
                allData.add(allDocs[i].data() as Map<String, dynamic>);
              }

              int Counter = allData[0]['count'] as int;
              Counter = ++Counter;
              return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Center(
                    child: Form(
                      key: controller,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Id : $Counter",
                                style: TextStyle(fontSize: 25)),
                            SizedBox(height: 20),
                            TextFormField(
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Enter You Name";
                                  }
                                  return null;
                                },
                                controller: namecontroller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text("Name"),
                                  hintText: "Enter Name ",
                                )),
                            SizedBox(height: 20),
                            TextFormField(
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Enter You 1 hours Price";
                                  }
                                  return null;
                                },
                                controller: pricecontroller,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text("Price"),
                                  hintText: "Enter 1 hours Price ",
                                )),
                            SizedBox(height: 10),
                            //selecte catagery
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Service name",
                                  style: TextStyle(fontSize: 20),
                                ),
                                StreamBuilder(
                                    stream: FireStoreHelper.fireStoreHelper
                                        .fecthchAllData(name: "service_data"),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                "error :${snapshot.hasError}"));
                                      } else if (snapshot.hasData) {
                                        QuerySnapshot? querySnapshort =
                                            snapshot.data;

                                        List<QueryDocumentSnapshot> allDocs =
                                            querySnapshort!.docs;
                                        List<Map<String, dynamic>> allData = [];

                                        for (int i = 0;
                                            i < allDocs.length;
                                            i++) {
                                          allData.add(allDocs[i].data()
                                              as Map<String, dynamic>);
                                        }
                                        bool a = false;
                                        aa() {
                                          if (a == false) {
                                            print("new");
                                            initalValue =
                                                "${allData[0]['category_name']}";
                                          }
                                        }

                                        return DropdownButtonHideUnderline(
                                          child: DropdownButton<dynamic>(
                                            value: initalValue,
                                            items: allData!
                                                .map((e) => DropdownMenuItem(
                                                      child: Text(
                                                          "  ${e['category_name']}"),
                                                      value:
                                                          "${e['category_name']}",
                                                    ))
                                                .toList(),
                                            onChanged: (val) {
                                              setState(() {
                                                initalValue = val;
                                                a = true;
                                              });
                                            },
                                          ),
                                        );
                                      }
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }),
                              ],
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                                maxLines: 3,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Enter You 1 Detail";
                                  }
                                  return null;
                                },
                                controller: detailcontroller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text("Detail"),
                                  hintText: "Enter You Detail ",
                                )),
                            SizedBox(height: 10),
                            Text(" Image  👇🏻"),
                            Align(
                              alignment: Alignment.center,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                      radius: 70,
                                      backgroundImage: (imagefile2 != null)
                                          ? FileImage(imagefile2!)
                                          : null),
                                  FloatingActionButton(
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: SelectableText(
                                                    "You Choise Is Image"),
                                                actions: [
                                                  IconButton(
                                                      onPressed: () async {
                                                        try {
                                                          var pickedFile =
                                                              await picker.pickImage(
                                                                  source:
                                                                      ImageSource
                                                                          .camera);
                                                          //you can use ImageCourse.camera for Camera capture
                                                          if (pickedFile !=
                                                              null) {
                                                            pathImage =
                                                                pickedFile.path;

                                                            //output /data/user/0/com.example.testapp/cache/image_picker7973898508152261600.jpg
                                                            setState(() {
                                                              imagefile2 = File(
                                                                  pathImage);
                                                            }); //convert Path to File
                                                            Uint8List
                                                                imagebytes =
                                                                await imagefile2!
                                                                    .readAsBytes();

                                                            imagebytes =
                                                                await testComporessList(
                                                                    imagebytes);
//convert to bytes
                                                            //convert bytes to base64 string

                                                            setState(() {
                                                              image =
                                                                  base64.encode(
                                                                      imagebytes);
                                                            });
                                                          } else {
                                                            print(
                                                                "No image is selected.");
                                                          }
                                                        } catch (e) {
                                                          print(
                                                              "error while picking file.");
                                                        }
                                                        setState(() {
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                      },
                                                      icon: Icon(Icons.camera)),
                                                  SizedBox(width: 40),
                                                  IconButton(
                                                      onPressed: () async {
                                                        try {
                                                          var pickedFile =
                                                              await picker.pickImage(
                                                                  source: ImageSource
                                                                      .gallery);
                                                          //you can use ImageCourse.camera for Camera capture
                                                          if (pickedFile !=
                                                              null) {
                                                            pathImage =
                                                                pickedFile.path;

                                                            //output /data/user/0/com.example.testapp/cache/image_picker7973898508152261600.jpg

                                                            setState(() {
                                                              imagefile2 = File(
                                                                  pathImage);
                                                            }); //convert Path to File
                                                            Uint8List
                                                                imagebytes =
                                                                await imagefile2!
                                                                    .readAsBytes();
                                                            imagebytes =
                                                                await testComporessList(
                                                                    imagebytes);

                                                            //convert to bytes

                                                            //convert bytes to base64 string

                                                            setState(() {
                                                              image =
                                                                  base64.encode(
                                                                      imagebytes);
                                                            });
                                                          } else {
                                                            print(
                                                                "No image is selected.");
                                                          }
                                                        } catch (e) {
                                                          print(
                                                              "error while picking file.");
                                                        }
                                                        setState(() {
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                      },
                                                      icon: Icon(Icons.album))
                                                ],
                                              ));
                                    },
                                    child: Icon(Icons.add),
                                    mini: true,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Text("$error",
                                style:
                                    TextStyle(fontSize: 25, color: Colors.red)),
                            ElevatedButton(
                                onPressed: () {
                                  if (controller.currentState!.validate()) {
                                    if (imagefile2 != null &&
                                        initalValue != null) {
                                      Map<String, dynamic> data = {
                                        "id": Counter.toInt(),
                                        "name": namecontroller.text,
                                        "price": pricecontroller.text,
                                        "service_name": initalValue.toString(),
                                        "detail": detailcontroller.text,
                                        "image": image,
                                      };
                                      Map<String, dynamic> counters = {
                                        "count": Counter
                                      };
                                      print(
                                          "===================================");

                                      print(data['id']);
                                      print(data['name']);
                                      print(data['price']);
                                      print(data['service_name']);
                                      print(data['detail']);
                                      print(data['image']);
                                      print(
                                          "===================================");
                                      FireStoreHelper.fireStoreHelper
                                          .insertData(
                                              name: "employee_data",
                                              data: data);
                                      FireStoreHelper.fireStoreHelper
                                          .UpdateCount(
                                              data: counters,
                                              name: "employee_counter");
                                      setState(() {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              backgroundColor: Colors.green,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              content: Text(
                                                  "You Recode Successfuly........")),
                                        );
                                        Navigator.of(context).pop();
                                      });
                                    } else {
                                      setState(() {
                                        error = "Enter You Image And Icon";
                                      });
                                    }
                                  }
                                },
                                child: Text("Save"))
                          ],
                        ),
                      ),
                    ),
                  ));
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
