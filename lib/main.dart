import 'dart:io';
import 'dart:typed_data';

import 'package:demo/helpers/db_helper.dart';
import 'package:demo/modal/students_modal.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    ),
  );
}

String? name;
int? age;
String? course;
GlobalKey<FormState> globalKey = GlobalKey<FormState>();

TextEditingController namecontroller = TextEditingController();
TextEditingController nameUpdatecontroller = TextEditingController();
TextEditingController ageUpdatecontroller = TextEditingController();
TextEditingController courseUpdatecontroller = TextEditingController();
TextEditingController agecontroller = TextEditingController();
TextEditingController coursecontroller = TextEditingController();

ImagePicker picker = ImagePicker();
File? imgfile;
Uint8List? imageBytes;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<student>> getAllData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllData = DBHleper.dbHleper.fetchAllRecode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("DataBase"), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: TextFormField(
                onChanged: (val) {
                  setState(() {
                    getAllData =
                        DBHleper.dbHleper.fetchSearchedRecode(data: val!);
                  });
                },
                decoration: InputDecoration(
                    hintText: "Search here.....",
                    prefixIcon: Icon(Icons.search))),
            flex: 2,
          ),
          Expanded(
            child: FutureBuilder(
              future: getAllData,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error is ${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  List<student>? data = snapshot.data;
                  return ListView.builder(
                    itemCount: data!.length,
                    itemBuilder: (context, i) {
                      return Card(
                        margin: EdgeInsets.all(10),
                        elevation: 7,
                        child: ListTile(
                          isThreeLine: true,
                          leading: CircleAvatar(
                              radius: 50,
                              backgroundImage: (data[i].image != null)
                                  ? MemoryImage(data[i].image!)
                                  : null),
                          title: Text("${data[i].name}"),
                          subtitle:
                              Text("${data[i].course}\nage : ${data[i].age}"),
                          trailing: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    nameUpdatecontroller.text = data[i].name;
                                    ageUpdatecontroller.text =
                                        data[i].age.toString();
                                    courseUpdatecontroller.text =
                                        data[i].course;
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Edit"),
                                          content: Form(
                                            key: globalKey,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      children: [
                                                        CircleAvatar(
                                                            radius: 70,
                                                            backgroundImage: (data[
                                                                            i]
                                                                        .image !=
                                                                    null)
                                                                ? MemoryImage(
                                                                    data[i]
                                                                        .image!)
                                                                : null),
                                                        Positioned(
                                                            top: 50,
                                                            right: 10,
                                                            child:
                                                                (data[i].image ==
                                                                        null)
                                                                    ? Text(
                                                                        "Add You Photo",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                17,
                                                                            color:
                                                                                Colors.white),
                                                                      )
                                                                    : Text("")),
                                                        FloatingActionButton(
                                                          onPressed: () async {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        AlertDialog(
                                                                          title:
                                                                              SelectableText("You Choise Is Image"),
                                                                          actions: [
                                                                            IconButton(
                                                                                onPressed: () async {
                                                                                  XFile? xfile = await picker.pickImage(source: ImageSource.camera);

                                                                                  futur() async {
                                                                                    imageBytes = await xfile!.readAsBytes();
                                                                                  }

                                                                                  setState(() {
                                                                                    futur();

                                                                                    Navigator.of(context).pop();
                                                                                  });
                                                                                },
                                                                                icon: Icon(Icons.camera)),
                                                                            SizedBox(width: 40),
                                                                            IconButton(
                                                                                onPressed: () async {
                                                                                  XFile? xfile = await picker.pickImage(source: ImageSource.gallery);

                                                                                  Uint8List ImageUint = await xfile!.readAsBytes();

                                                                                  setState(() {
                                                                                    imageBytes = ImageUint;

                                                                                    Navigator.of(context).pop();
                                                                                  });
                                                                                },
                                                                                icon: Icon(Icons.photo_album_rounded))
                                                                          ],
                                                                        ));
                                                          },
                                                          child:
                                                              Icon(Icons.add),
                                                          mini: true,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 20),
                                                  TextFormField(
                                                      controller:
                                                          nameUpdatecontroller,
                                                      validator: (val) {
                                                        if (val!.isEmpty) {
                                                          return "Enter You Name";
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (val) {
                                                        name = val;
                                                      },
                                                      decoration: InputDecoration(
                                                          label: Text(
                                                              "Enter You Name"),
                                                          border:
                                                              OutlineInputBorder())),
                                                  SizedBox(height: 20),
                                                  TextFormField(
                                                      controller:
                                                          ageUpdatecontroller,
                                                      validator: (val) {
                                                        if (val!.isEmpty) {
                                                          return "Enter You age";
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (val) {
                                                        age = int.parse(val!);
                                                      },
                                                      keyboardType:
                                                          TextInputType.number,
                                                      maxLength: 2,
                                                      decoration: InputDecoration(
                                                          label: Text(
                                                              "Enter You age"),
                                                          border:
                                                              OutlineInputBorder())),
                                                  SizedBox(height: 10),
                                                  TextFormField(
                                                      controller:
                                                          courseUpdatecontroller,
                                                      validator: (val) {
                                                        if (val!.isEmpty) {
                                                          return "Enter You Course";
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (val) {
                                                        course = val;
                                                      },
                                                      decoration: InputDecoration(
                                                          label: Text(
                                                              "Enter You Course"),
                                                          border:
                                                              OutlineInputBorder())),
                                                  SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ElevatedButton(
                                                          onPressed: () async {
                                                            if (globalKey
                                                                .currentState!
                                                                .validate()) {
                                                              globalKey
                                                                  .currentState!
                                                                  .save();
                                                              student s1 = student(
                                                                  name: name!,
                                                                  age: age!,
                                                                  course:
                                                                      course!,
                                                                  image: (imageBytes ==
                                                                          null)
                                                                      ? data[i]
                                                                          .image
                                                                      : imageBytes);
                                                              int? id = await DBHleper
                                                                  .dbHleper
                                                                  .updateRecode(
                                                                      data: s1,
                                                                      id: data[
                                                                              i]
                                                                          .id!);
                                                              print(id);
                                                              setState(() {
                                                                if (id! == 1) {
                                                                  getAllData = DBHleper
                                                                      .dbHleper
                                                                      .fetchAllRecode();
                                                                  name = null;
                                                                  age = null;
                                                                  course = null;
                                                                  imageBytes =
                                                                      null;
                                                                  nameUpdatecontroller
                                                                      .clear();
                                                                  ageUpdatecontroller
                                                                      .clear();
                                                                  coursecontroller
                                                                      .clear();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  imageBytes =
                                                                      null;
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    content: Text(
                                                                        "Record Update Successfully with id : ${id}"),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green,
                                                                    behavior:
                                                                        SnackBarBehavior
                                                                            .floating,
                                                                  ));
                                                                } else {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    content: Text(
                                                                        "Record Update failed......"),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .redAccent,
                                                                    behavior:
                                                                        SnackBarBehavior
                                                                            .floating,
                                                                  ));
                                                                }
                                                              });
                                                            }
                                                          },
                                                          child: Text("SAVE")),
                                                      SizedBox(width: 30),
                                                      OutlinedButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              namecontroller
                                                                  .clear();
                                                              agecontroller
                                                                  .clear();
                                                              coursecontroller
                                                                  .clear();

                                                              name = null;
                                                              age = null;
                                                              course = null;
                                                              imageBytes = null;

                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          },
                                                          child:
                                                              Text("Cancel")),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  )),
                              SizedBox(width: 5),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              "Ready To Delete Your Data\n"),
                                          shape: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blueAccent,
                                                  width: 5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          content: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    int? id = await DBHleper
                                                        .dbHleper
                                                        .deleteRecode(
                                                            id: data[i].id!);
                                                    if (id == 1) {
                                                      setState(() {
                                                        getAllData = DBHleper
                                                            .dbHleper
                                                            .fetchAllRecode();
                                                        Navigator.of(context)
                                                            .pop();
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    "You Data Is Deleyed...."),
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                behavior:
                                                                    SnackBarBehavior
                                                                        .floating));
                                                      });
                                                    }
                                                  },
                                                  child: Text("Yes")),
                                              SizedBox(width: 20),
                                              OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("No"))
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red)),
                            ],
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
            ),
            flex: 13,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            imageBytes = null;
            namecontroller.clear();
            agecontroller.clear();
            coursecontroller.clear();
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Form(
                  key: globalKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                                radius: 70,
                                backgroundImage: (imageBytes != null)
                                    ? MemoryImage(imageBytes!)
                                    : null),
                            Positioned(
                                top: 50,
                                right: 10,
                                child: (imageBytes == null)
                                    ? Text(
                                        "Add You Photo",
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white),
                                      )
                                    : Text("")),
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
                                                  XFile? xfile =
                                                      await picker.pickImage(
                                                          source: ImageSource
                                                              .camera);

                                                  futur() async {
                                                    imageBytes = await xfile!
                                                        .readAsBytes();
                                                  }

                                                  setState(() {
                                                    futur();

                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                                icon: Icon(Icons.camera)),
                                            SizedBox(width: 40),
                                            IconButton(
                                                onPressed: () async {
                                                  XFile? xfile =
                                                      await picker.pickImage(
                                                          source: ImageSource
                                                              .gallery);

                                                  Uint8List ImageUint =
                                                      await xfile!
                                                          .readAsBytes();

                                                  setState(() {
                                                    imageBytes = ImageUint;

                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                                icon: Icon(
                                                    Icons.photo_album_rounded))
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
                      TextFormField(
                          controller: namecontroller,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter You Name";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            name = val;
                          },
                          decoration: InputDecoration(
                              label: Text("Enter You Name"),
                              border: OutlineInputBorder())),
                      SizedBox(height: 20),
                      TextFormField(
                          controller: agecontroller,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter You age";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            age = int.parse(val!);
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          decoration: InputDecoration(
                              label: Text("Enter You age"),
                              border: OutlineInputBorder())),
                      SizedBox(height: 10),
                      TextFormField(
                          controller: coursecontroller,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter You Course";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            course = val;
                          },
                          decoration: InputDecoration(
                              label: Text("Enter You Course"),
                              border: OutlineInputBorder())),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                if (globalKey.currentState!.validate()) {
                                  globalKey.currentState!.save();

                                  student s1 = student(
                                      name: name!,
                                      age: age!,
                                      course: course!,
                                      image: imageBytes);
                                  int? id = await DBHleper.dbHleper
                                      .inserRecode(data: s1);

                                  setState(() {
                                    if (id! >= 1) {
                                      getAllData =
                                          DBHleper.dbHleper.fetchAllRecode();
                                      name = null;
                                      age = null;
                                      course = null;
                                      namecontroller.clear();
                                      agecontroller.clear();
                                      coursecontroller.clear();
                                      Navigator.of(context).pop();
                                      imageBytes = null;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Record inserted Successfully with id : ${id}"),
                                        backgroundColor: Colors.green,
                                        behavior: SnackBarBehavior.floating,
                                      ));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Record inserted failed......"),
                                        backgroundColor: Colors.redAccent,
                                        behavior: SnackBarBehavior.floating,
                                      ));
                                    }
                                  });
                                }
                              },
                              child: Text("SAVE")),
                          SizedBox(width: 30),
                          OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  namecontroller.clear();
                                  agecontroller.clear();
                                  coursecontroller.clear();

                                  name = null;
                                  age = null;
                                  course = null;
                                  imageBytes = null;

                                  Navigator.of(context).pop();
                                });
                              },
                              child: Text("Cancel")),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
