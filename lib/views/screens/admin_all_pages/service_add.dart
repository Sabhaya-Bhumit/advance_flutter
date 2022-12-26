import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_service_app/views/screens/admin_all_pages/employee_add.dart';
import 'package:image_picker/image_picker.dart';

import '../../../helper/firestore_helper.dart';

class Service_Add extends StatefulWidget {
  const Service_Add({Key? key}) : super(key: key);

  @override
  State<Service_Add> createState() => _Service_AddState();
}

class _Service_AddState extends State<Service_Add> {
  String? icon;
  String? image;

  File? imagefile1;
  File? imagefile2;

  String pathIcon = "";
  String pathImage = "";

  String error = "";

  TextEditingController category_name = TextEditingController();
  TextEditingController Details = TextEditingController();

  final GlobalKey<FormState> controller = GlobalKey<FormState>();

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagefile1 = null;
    imagefile2 = null;
    category_name.clear();
    Details.clear();
    image = "";
    icon = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Service Add"), centerTitle: true),
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
              int Counter = allData[1]['count'] as int;
              Counter = ++Counter;
              return Padding(
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: Form(
                    key: controller,
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Id : ${Counter}",
                                style: TextStyle(fontSize: 25)),
                            SizedBox(height: 20),
                            TextFormField(
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Enter You Category Name";
                                  }
                                  return null;
                                },
                                controller: category_name,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter Category Name",
                                )),
                            SizedBox(height: 20),
                            TextFormField(
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Enter You Detail";
                                  }
                                  return null;
                                },
                                controller: Details,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter Details ",
                                )),
                            SizedBox(height: 20),
                            Text("icon change 👇🏻"),
                            Align(
                              alignment: Alignment.center,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 70,
                                    backgroundImage: (imagefile1 != null)
                                        ? FileImage(imagefile1!)
                                        : null,
                                  ),
                                  FloatingActionButton(
                                    heroTag: null,
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
                                                            pathIcon =
                                                                pickedFile.path;

                                                            File imagefile1 = File(
                                                                pathIcon); //convert Path to File
                                                            Uint8List
                                                                imagebytes =
                                                                await imagefile1
                                                                    .readAsBytes();

                                                            imagebytes =
                                                                await testComporessList(
                                                                    imagebytes); //convert to bytes

                                                            setState(() {
                                                              icon =
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
                                                            pathIcon =
                                                                pickedFile.path;

                                                            //output /data/user/0/com.example.testapp/cache/image_picker7973898508152261600.jpg

                                                            setState(() {
                                                              imagefile1 = File(
                                                                  pathIcon);
                                                            }); //convert Path to File
                                                            Uint8List
                                                                imagebytes =
                                                                await imagefile1!
                                                                    .readAsBytes();
                                                            imagebytes =
                                                                await testComporessList(
                                                                    imagebytes);

                                                            ///convert to bytes
                                                            //convert bytes to base64 string

                                                            setState(() {
                                                              icon =
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
                            Text(" Image change 👇🏻"),
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
                                    heroTag: null,
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
                                                                    .readAsBytes(); //convert to bytes
                                                            //convert bytes to base64 string
                                                            imagebytes =
                                                                await testComporessList(
                                                                    imagebytes);
                                                            setState(() {
                                                              image =
                                                                  base64.encode(
                                                                      imagebytes);

                                                              print(
                                                                  "-----------------------------------");
                                                              print(image);
                                                              print(
                                                                  "-----------------------------------");
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
                                                                    .readAsBytes(); //convert to bytes
                                                            //convert bytes to base64 string
                                                            imagebytes =
                                                                await testComporessList(
                                                                    imagebytes);
                                                            setState(() {
                                                              image =
                                                                  base64.encode(
                                                                      imagebytes);
                                                              print(
                                                                  "-----------------------------------");
                                                              print(image);
                                                              print(
                                                                  "-----------------------------------");
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
                            ElevatedButton(
                                onPressed: () {
                                  if (controller.currentState!.validate()) {
                                    if (imagefile1 != null &&
                                        imagefile2 != null) {
                                      Map<String, dynamic> data = {
                                        "id": Counter,
                                        "category_name": category_name.text,
                                        "detail": Details.text,
                                        "icon": icon,
                                        "images": image
                                      };
                                      Map<String, dynamic> counters = {
                                        "count": Counter
                                      };

                                      FireStoreHelper.fireStoreHelper
                                          .insertData(
                                              name: "service_data", data: data);
                                      FireStoreHelper.fireStoreHelper
                                          .UpdateCount(
                                              data: counters,
                                              name: "service_counter");
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
                                child: Text("Save")),
                            Text(
                              "$error",
                              style: TextStyle(fontSize: 25, color: Colors.red),
                            )
                          ]),
                    ),
                  ),
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
