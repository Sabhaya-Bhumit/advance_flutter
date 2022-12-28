import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebace_app/helper/firebase_auth_helper.dart';
import 'package:firebace_app/helper/firestore_helper.dart';
import 'package:firebace_app/helper/local_notification_helper.dart';
import 'package:firebace_app/views/components/MyDrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timezone/data/latest.dart' as tz;

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

ImagePicker imagePicker = ImagePicker();
final GlobalKey<FormState> controller = GlobalKey<FormState>();

TextEditingController namecontroller = TextEditingController();
TextEditingController agecontroller = TextEditingController();
TextEditingController courscontroller = TextEditingController();

String? name;
String? cours;
int? age;

String imagepath = "";

String? image;

Uint8List? decodedbytes;

class _homeState extends State<home> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    var adroidIntialzeSettings =
        AndroidInitializationSettings("mipmap/ic_launcher");
    var iosIntialzeSettings = DarwinInitializationSettings();
    var initalizeSettins = InitializationSettings(
        android: adroidIntialzeSettings, iOS: iosIntialzeSettings);

    tz.initializeTimeZones();

    LocalNotificationHelper.flutterLocalNotificationsPlugin
        .initialize(initalizeSettins,
            onDidReceiveNotificationResponse: (NotificationResponse response) {
      print("================");
      print(response);
      print("================");
    });
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
    User user = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: Text(" Home Page"),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuthHelper.firebaseAuthHelper.singOutUser();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('login_page', (route) => false);
              },
              icon: Icon(Icons.power_settings_new_outlined))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            name = null;
            age = null;
            cours = null;
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text("Add Recode"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StreamBuilder(
                            stream:
                                FireStoreHelper.fireStoreHelper.fecthchCount(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text("Error is :${snapshot.error}"));
                              } else if (snapshot.hasData) {
                                QuerySnapshot? querySnapshort = snapshot.data;
                                List<QueryDocumentSnapshot> allDocs =
                                    querySnapshort!.docs;
                                int count = allDocs[0]['counter'];
                                count = ++count;
                                return Form(
                                  key: controller,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 15),
                                      Text("Id : ${count}"),
                                      SizedBox(height: 15),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            CircleAvatar(
                                              radius: 70,
                                              backgroundImage: (decodedbytes !=
                                                      null)
                                                  ? MemoryImage(decodedbytes!)
                                                  : null,
                                            ),
                                            Positioned(
                                                top: 50,
                                                child: (decodedbytes == null)
                                                    ? Text(
                                                        "Add Photo       ",
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    : Text("")),
                                            FloatingActionButton(
                                              onPressed: () async {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (context) =>
                                                            AlertDialog(
                                                              title: SelectableText(
                                                                  "You Choise Is Image"),
                                                              actions: [
                                                                IconButton(
                                                                    onPressed:
                                                                        () async {
                                                                      try {
                                                                        var pickedFile =
                                                                            await imagePicker.pickImage(source: ImageSource.camera);
                                                                        //you can use ImageCourse.camera for Camera capture
                                                                        if (pickedFile !=
                                                                            null) {
                                                                          imagepath =
                                                                              pickedFile.path;

                                                                          //output /data/user/0/com.example.testapp/cache/image_picker7973898508152261600.jpg

                                                                          File
                                                                              imagefile =
                                                                              File(imagepath); //convert Path to File
                                                                          Uint8List
                                                                              imagebytes =
                                                                              await imagefile.readAsBytes(); //convert to bytes
                                                                          //convert bytes to base64 string

                                                                          setState(
                                                                              () {
                                                                            image =
                                                                                base64.encode(imagebytes);
                                                                            decodedbytes =
                                                                                base64.decode(image!);
                                                                          });
                                                                        } else {
                                                                          print(
                                                                              "No image is selected.");
                                                                        }
                                                                      } catch (e) {
                                                                        print(
                                                                            "error while picking file.");
                                                                      }
                                                                      setState(
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      });
                                                                    },
                                                                    icon: Icon(Icons
                                                                        .camera)),
                                                                SizedBox(
                                                                    width: 40),
                                                                IconButton(
                                                                    onPressed:
                                                                        () async {
                                                                      try {
                                                                        var pickedFile =
                                                                            await imagePicker.pickImage(source: ImageSource.gallery);
                                                                        //you can use ImageCourse.camera for Camera capture
                                                                        if (pickedFile !=
                                                                            null) {
                                                                          imagepath =
                                                                              pickedFile.path;

                                                                          //output /data/user/0/com.example.testapp/cache/image_picker7973898508152261600.jpg

                                                                          File
                                                                              imagefile =
                                                                              File(imagepath); //convert Path to File
                                                                          Uint8List
                                                                              imagebytes =
                                                                              await imagefile.readAsBytes(); //convert to bytes
                                                                          //convert bytes to base64 string

                                                                          setState(
                                                                              () {
                                                                            image =
                                                                                base64.encode(imagebytes);
                                                                            decodedbytes =
                                                                                base64.decode(image!);
                                                                          });
                                                                        } else {
                                                                          print(
                                                                              "No image is selected.");
                                                                        }
                                                                      } catch (e) {
                                                                        print(
                                                                            "error while picking file.");
                                                                      }
                                                                      setState(
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      });
                                                                    },
                                                                    icon: Icon(Icons
                                                                        .album))
                                                              ],
                                                            ));
                                              },
                                              child: Icon(Icons.add),
                                              mini: true,
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      TextFormField(
                                          validator: (val) {
                                            if (val!.isEmpty) {
                                              return "Enter Valid Name";
                                            }
                                          },
                                          onSaved: (val) {
                                            name = val;
                                          },
                                          decoration: InputDecoration(
                                            label: Text("Name"),
                                            hintText: "Enter You Name",
                                            border: OutlineInputBorder(),
                                          )),
                                      SizedBox(height: 15),
                                      TextFormField(
                                          onSaved: (val) {
                                            age = int.parse(val.toString());
                                          },
                                          validator: (val) {
                                            if (val!.isEmpty) {
                                              return "Enter Valid Age";
                                            }
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            label: Text("Age"),
                                            hintText: "Enter You age",
                                            border: OutlineInputBorder(),
                                          )),
                                      SizedBox(height: 15),
                                      TextFormField(
                                          onSaved: (val) {
                                            cours = val;
                                          },
                                          validator: (val) {
                                            if (val!.isEmpty) {
                                              return "Enter Valid Cours";
                                            }
                                          },
                                          decoration: InputDecoration(
                                            label: Text("Cours"),
                                            hintText: "Enter You Cours",
                                            border: OutlineInputBorder(),
                                          )),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () async {
                                                if (controller.currentState!
                                                    .validate()) {
                                                  controller.currentState!
                                                      .save();
                                                  Map<String, dynamic> data = {
                                                    'id': count,
                                                    'name': name,
                                                    'age': age,
                                                    'cours': cours,
                                                    'image': imagepath
                                                  };
                                                  Map<String, dynamic> data2 = {
                                                    'counter': count
                                                  };

                                                  FireStoreHelper
                                                      .fireStoreHelper
                                                      .inserttData(data: data);
                                                  FireStoreHelper
                                                      .fireStoreHelper
                                                      .UpdateCount(data: data2);

                                                  LocalNotificationHelper
                                                      .localNotificationHelper
                                                      .sendScheduleNotifincation(
                                                          id: data['id']);

                                                  name = null;
                                                  age = null;
                                                  cours = null;
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                              child: Text("Save")),
                                          OutlinedButton(
                                              onPressed: () {
                                                name = null;
                                                age = null;
                                                cours = null;
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Cancel"))
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }
                              return Center(child: CircularProgressIndicator());
                            },
                          )
                        ],
                      ),
                    ));
          },
          child: Icon(Icons.add)),
      body: Center(
          child: StreamBuilder(
        stream: FireStoreHelper.fireStoreHelper
            .fecthchAllData(name: "service_data"),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error : ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot? querySnapshort = snapshot.data;

            List<QueryDocumentSnapshot> allDocs = querySnapshort!.docs;

            return ListView.builder(
              itemCount: allDocs.length,
              itemBuilder: (context, i) {
                Map<String, dynamic> data =
                    allDocs[i].data() as Map<String, dynamic>;

                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    elevation: 10,
                    child: ListTile(
                      isThreeLine: true,
                      title: Text(
                        "${data['name']}",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w400),
                      ),
                      subtitle: Text("${data['cours']}\nAge : ${data['age']}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300)),
                      leading: CircleAvatar(
                          child: Text("${data['id']}"), radius: 30),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                namecontroller.clear();
                                agecontroller.clear();
                                courscontroller.clear();
                                namecontroller.text = "${data['name']}";
                                agecontroller.text = "${data['age']}";
                                courscontroller.text = "${data['cours']}";
                                name = null;
                                age = null;
                                cours = null;
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text("Add Recode"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              StreamBuilder(
                                                stream: FireStoreHelper
                                                    .fireStoreHelper
                                                    .fecthchCount(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasError) {
                                                    return Center(
                                                        child: Text(
                                                            "Error is :${snapshot.error}"));
                                                  } else if (snapshot.hasData) {
                                                    QuerySnapshot?
                                                        querySnapshort =
                                                        snapshot.data;
                                                    List<QueryDocumentSnapshot>
                                                        allDocs =
                                                        querySnapshort!.docs;
                                                    int count =
                                                        allDocs[0]['counter'];
                                                    count = ++count;
                                                    return Form(
                                                      key: controller,
                                                      child: Column(
                                                        children: [
                                                          SizedBox(height: 15),
                                                          Text(
                                                              "Id : ${data['id']}"),
                                                          SizedBox(height: 15),
                                                          TextFormField(
                                                              controller:
                                                                  namecontroller,
                                                              validator: (val) {
                                                                if (val!
                                                                    .isEmpty) {
                                                                  return "Enter Valid Name";
                                                                }
                                                              },
                                                              onSaved: (val) {
                                                                name = val;
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                label: Text(
                                                                    "Name"),
                                                                hintText:
                                                                    "Enter You Name",
                                                                border:
                                                                    OutlineInputBorder(),
                                                              )),
                                                          SizedBox(height: 15),
                                                          TextFormField(
                                                              controller:
                                                                  agecontroller,
                                                              onSaved: (val) {
                                                                age = int.parse(
                                                                    val.toString());
                                                              },
                                                              validator: (val) {
                                                                if (val!
                                                                    .isEmpty) {
                                                                  return "Enter Valid Age";
                                                                }
                                                              },
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              decoration:
                                                                  InputDecoration(
                                                                label:
                                                                    Text("Age"),
                                                                hintText:
                                                                    "Enter You age",
                                                                border:
                                                                    OutlineInputBorder(),
                                                              )),
                                                          SizedBox(height: 15),
                                                          TextFormField(
                                                              controller:
                                                                  courscontroller,
                                                              onSaved: (val) {
                                                                cours = val;
                                                              },
                                                              validator: (val) {
                                                                if (val!
                                                                    .isEmpty) {
                                                                  return "Enter Valid Cours";
                                                                }
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                label: Text(
                                                                    "Cours"),
                                                                hintText:
                                                                    "Enter You Cours",
                                                                border:
                                                                    OutlineInputBorder(),
                                                              )),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    if (controller
                                                                        .currentState!
                                                                        .validate()) {
                                                                      controller
                                                                          .currentState!
                                                                          .save();
                                                                      Map<String,
                                                                              dynamic>
                                                                          data2 =
                                                                          {
                                                                        'id': int.parse(
                                                                            data['id'].toString()),
                                                                        'name':
                                                                            namecontroller.text,
                                                                        'age': int.parse(
                                                                            agecontroller.text),
                                                                        'cours':
                                                                            courscontroller.text
                                                                      };

                                                                      FireStoreHelper
                                                                          .fireStoreHelper
                                                                          .UpdateRecode(
                                                                              data: data2,
                                                                              id: data2['id'].toString());

                                                                      LocalNotificationHelper
                                                                          .localNotificationHelper
                                                                          .sendSimpleNotication(
                                                                              id: data['id']);

                                                                      name =
                                                                          null;
                                                                      age =
                                                                          null;
                                                                      cours =
                                                                          null;
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                      "Save")),
                                                              OutlinedButton(
                                                                  onPressed:
                                                                      () {
                                                                    name = null;
                                                                    age = null;
                                                                    cours =
                                                                        null;
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                      "Cancel"))
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                },
                                              )
                                            ],
                                          ),
                                        ));
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.lightBlue,
                              )),
                          IconButton(
                              onPressed: () async {
                                await FireStoreHelper.fireStoreHelper
                                    .DeleteRecode(
                                        id: data['id'].toString(), data: data);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      )),
      drawer: myDrower(user: user),
    );
  }
}
