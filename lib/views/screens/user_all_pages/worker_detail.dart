import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_service_app/helper/firestore_helper.dart';

class worker_detail extends StatefulWidget {
  const worker_detail({Key? key}) : super(key: key);

  @override
  State<worker_detail> createState() => _worker_detailState();
}

class _worker_detailState extends State<worker_detail> {
  @override
  Widget build(BuildContext context) {
    dynamic res = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
        appBar: AppBar(title: Text("$res"), centerTitle: true, elevation: 0),
        body: StreamBuilder(
            stream: FireStoreHelper.fireStoreHelper
                .fecthchAllData(name: "employee_data"),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Error ${snapshot.error}"));
              } else if (snapshot.hasData) {
                QuerySnapshot? querySnapshort = snapshot.data;

                List<QueryDocumentSnapshot> allDocs = querySnapshort!.docs;

                List<Map<String, dynamic>> Data = [];
                List<Map<String, dynamic>> allData = [];
                List images = [];
                for (int i = 0; i < allDocs.length; i++) {
                  Data.add(allDocs[i].data() as Map<String, dynamic>);
                  if (res == Data[i]['service_name']) {
                    allData.add(Data[i]);
                    print(allData[i]);
                    Uint8List imageU = base64.decode(Data[i]['image']);
                    images.add(imageU);
                  }
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 15,
                      // mainAxisExtent: 15,

                      childAspectRatio: 1),
                  itemCount: allData.length,
                  itemBuilder: (context, i) {
                    return Container(
                      height: 200,
                      color: Colors.blueAccent,
                      child: Column(
                        children: [
                          Text("${allData[i]['name']}"),
                        ],
                      ),
                    );
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}
