import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_service_app/helper/firestore_helper.dart';
import 'package:image_picker/image_picker.dart';

class Service_Update extends StatefulWidget {
  const Service_Update({Key? key}) : super(key: key);

  @override
  State<Service_Update> createState() => _Service_UpdateState();
}

// new service Add

//

class _Service_UpdateState extends State<Service_Update> {
  final ImagePicker picker = ImagePicker();
  File? imgfile;
  File? imgfile2;
  String imagepath = "";

  String? image;
  String imagepath2 = "";

  String? image2;

  TextEditingController category_name = TextEditingController();
  TextEditingController detail = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic res = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: (res == 1)
            ? Text("Service UpDate and delete")
            : (res == 2)
                ? Text("Employee UpDate and delete")
                : (res == 3)
                    ? Text("Service Add")
                    : Text("Employee Add"),
      ),
      body: IndexedStack(
        index: res - 1,
        children: [
          //service Update
          StreamBuilder(
            stream: FireStoreHelper.fireStoreHelper
                .fecthchAllData(name: "service_data"),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("error :${snapshot.hasError}"));
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

                return Card(
                  elevation: 5,
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 10);
                    },
                    itemCount: allData.length,
                    itemBuilder: (context, i) {
                      return Row(children: [
                        Container(
                          // height: 100,
                          width: 285,
                          color: Colors.blue,
                          child: Column(
                            children: [
                              Text("Name : ${allData[i]['category_name']}"),
                              SizedBox(height: 10),
                              Text("detail : ${allData[i]['detail']}"),
                              SizedBox(height: 20),
                              Text("icon  👇🏻"),
                              Image.memory(icons[i], height: 150),
                              SizedBox(height: 20),
                              Text("image  👇🏻"),
                              Image.memory(images[i], height: 150),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              image = "${allData[i]['icon']}";
                              image2 = "${allData[i]['images']}";
                              Uint8List updateicon = base64.decode(image!);

                              Uint8List updateimage = base64.decode(image2!);
                              category_name.text =
                                  "${allData[i]['category_name']}";
                              detail.text = "${allData[i]['detail']}";
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                      "${allData[i]['category_name']} Is UpDate"),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("ID : ${allData[i]['id']}"),
                                        SizedBox(height: 10),
                                        TextFormField(
                                          controller: category_name,
                                          decoration: InputDecoration(
                                              label: Text("Category_Name"),
                                              border: OutlineInputBorder(),
                                              hintText: "Enter You"),
                                        ),
                                        SizedBox(height: 30),
                                        TextFormField(
                                          controller: detail,
                                          maxLines: 5,
                                          decoration: InputDecoration(
                                            label: Text("Details"),
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        SizedBox(height: 30),
                                        Text("icon change 👇🏻"),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Stack(
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              CircleAvatar(
                                                  radius: 70,
                                                  backgroundImage:
                                                      MemoryImage(updateicon)),
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
                                                                              await picker.pickImage(source: ImageSource.camera);
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

                                                                            setState(() {
                                                                              image = base64.encode(imagebytes);
                                                                            });
                                                                          } else {
                                                                            print("No image is selected.");
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
                                                                      icon: Icon(
                                                                          Icons
                                                                              .camera)),
                                                                  SizedBox(
                                                                      width:
                                                                          40),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () async {
                                                                        try {
                                                                          var pickedFile =
                                                                              await picker.pickImage(source: ImageSource.gallery);
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

                                                                            setState(() {
                                                                              image = base64.encode(imagebytes);
                                                                            });
                                                                          } else {
                                                                            print("No image is selected.");
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
                                                                      icon: Icon(
                                                                          Icons
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
                                        SizedBox(height: 30),
                                        Text("image Change 👇🏻"),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Stack(
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              CircleAvatar(
                                                  radius: 70,
                                                  backgroundImage:
                                                      MemoryImage(updateimage)),
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
                                                                              await picker.pickImage(source: ImageSource.camera);
                                                                          //you can use ImageCourse.camera for Camera capture
                                                                          if (pickedFile !=
                                                                              null) {
                                                                            imagepath2 =
                                                                                pickedFile.path;

                                                                            //output /data/user/0/com.example.testapp/cache/image_picker7973898508152261600.jpg

                                                                            File
                                                                                imagefile =
                                                                                File(imagepath2); //convert Path to File
                                                                            Uint8List
                                                                                imagebytes =
                                                                                await imagefile.readAsBytes(); //convert to bytes
                                                                            //convert bytes to base64 string

                                                                            setState(() {
                                                                              image2 = base64.encode(imagebytes);
                                                                            });
                                                                          } else {
                                                                            print("No image is selected.");
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
                                                                      icon: Icon(
                                                                          Icons
                                                                              .camera)),
                                                                  SizedBox(
                                                                      width:
                                                                          40),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () async {
                                                                        try {
                                                                          var pickedFile =
                                                                              await picker.pickImage(source: ImageSource.gallery);
                                                                          //you can use ImageCourse.camera for Camera capture
                                                                          if (pickedFile !=
                                                                              null) {
                                                                            imagepath2 =
                                                                                pickedFile.path;

                                                                            //output /data/user/0/com.example.testapp/cache/image_picker7973898508152261600.jpg

                                                                            File
                                                                                imagefile =
                                                                                File(imagepath2); //convert Path to File
                                                                            Uint8List
                                                                                imagebytes =
                                                                                await imagefile.readAsBytes(); //convert to bytes
                                                                            //convert bytes to base64 string

                                                                            setState(() {
                                                                              image2 = base64.encode(imagebytes);
                                                                            });
                                                                          } else {
                                                                            print("No image is selected.");
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
                                                                      icon: Icon(
                                                                          Icons
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
                                        SizedBox(height: 30),
                                        ElevatedButton(
                                            onPressed: () {
                                              Map<String, dynamic> data = {
                                                'category_name':
                                                    category_name.text,
                                                'detail': detail.text,
                                                'icon': image!,
                                                'images': image2!
                                              };
                                              print(data['detail']);
                                              print(allDocs[i].id);
                                              FireStoreHelper.fireStoreHelper
                                                  .UpdateRecode(
                                                      name: "service_data",
                                                      id: allData[i]['id']
                                                          .toString(),
                                                      data: data);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      backgroundColor:
                                                          Colors.green,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      content: Text(
                                                          "Update Recode Successfuly........")));
                                              detail.clear();
                                              category_name.clear();
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Update Now"))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                          "Delete Recode Successfuly........")));
                            },
                            icon: Icon(Icons.delete)),
                      ]);
                    },
                  ),
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
          //Employee Update
          Text("2"),
          //Service add

          //Employee Add
          Text("4"),
        ],
      ),
    );
  }
}
