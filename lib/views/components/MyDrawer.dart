import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class myDrower extends StatefulWidget {
  User? user;
  @override
  State<myDrower> createState() => _myDrowerState();
  myDrower({required this.user});
}

bool name = false;
String _name = "";

final ImagePicker picker = ImagePicker();
File? imgfile;
Uint8List? memoryImage;

class _myDrowerState extends State<myDrower> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(height: 100),
          Align(
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                (widget.user!.isAnonymous)
                    ? CircleAvatar(radius: 0)
                    : CircleAvatar(
                        radius: 70,
                        backgroundImage: (widget.user!.emailVerified)
                            ? NetworkImage("${widget.user!.photoURL}")
                            : null),
                Positioned(
                    top: 50,
                    child: (imgfile == null)
                        ? (widget.user!.emailVerified)
                            ? Text("")
                            : Text(
                                "Add Shoping Logo",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white),
                              )
                        : Text("")),
                (widget.user!.isAnonymous != true &&
                        widget.user!.emailVerified != true)
                    ? FloatingActionButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title:
                                        SelectableText("You Choise Is Image"),
                                    actions: [
                                      IconButton(
                                          onPressed: () async {
                                            XFile? image =
                                                await picker.pickImage(
                                                    source: ImageSource.camera);
                                            memoryImage = await image!
                                                .readAsBytes() as Uint8List?;
                                            setState(() {
                                              imgfile = File(image!.path);
                                              // global.myimage = imgfile;

                                              Navigator.of(context).pop();
                                            });
                                          },
                                          icon: Icon(Icons.camera)),
                                      SizedBox(width: 40),
                                      IconButton(
                                          onPressed: () async {
                                            XFile? image =
                                                await picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            memoryImage = await image!
                                                .readAsBytes() as Uint8List?;
                                            setState(() {
                                              imgfile = File(image!.path);

                                              Navigator.of(context).pop();
                                            });
                                          },
                                          icon: Icon(Icons.album))
                                    ],
                                  ));
                        },
                        child: Icon(Icons.add),
                        mini: true,
                      )
                    : Text(""),
              ],
            ),
          ),
          (widget.user!.isAnonymous)
              ? Text("Anonymous User")
              : (widget.user!.emailVerified)
                  ? Text("name = ${widget.user!.displayName}")
                  : Row(
                      children: [
                        SizedBox(width: 50),
                        (name)
                            ? SizedBox(
                                height: 50,
                                width: 150,
                                child: TextFormField(onFieldSubmitted: (val) {
                                  setState(() {
                                    _name = val;
                                    name = !name;
                                  });
                                }),
                              )
                            : Text(
                                "${(_name != null) ? "Enter You Name" : "You Name : "}${_name}"),
                        SizedBox(width: 25),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                print(name);
                                name = !name;
                              });
                            },
                            icon: Icon(Icons.edit)),
                      ],
                    )
        ],
      ),
    );
  }
}
