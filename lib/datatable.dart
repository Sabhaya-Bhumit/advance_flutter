import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/helpers/data_api_helper.dart';
import 'package:untitled/modal/modal.dart';

class datatable extends StatefulWidget {
  const datatable({Key? key}) : super(key: key);

  @override
  State<datatable> createState() => _datatableState();
}

List Data = [];
List<json_data>? API_Data;

class _datatableState extends State<datatable> {
  decodedata() async {
    String res = await rootBundle.loadString("assets/json/my_data.json");

    Map decodeData = jsonDecode(res);
    List list = decodeData['feeds'];
    setState(() {
      Data = list.map((e) {
        return json_data.fromMap(data: e);
      }).toList();
    });
  }

  int _isvalue = 0;
  bool _isAsc = true;
  int _isvalue2 = 0;
  bool _isAsc2 = true;
  List _selected = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    decodedata();
    _selected = List<bool>.generate(Data.length, (int index) => false);
  }

  @override
  Widget build(BuildContext context) {
    dynamic res = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
          title:
              (res == 0) ? Text("API In DataTable") : Text("Json In DataTable"),
          centerTitle: true),
      body: Container(
        child: IndexedStack(
          index: res,
          children: [
            Container(
                child: SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: FutureBuilder(
                  future: data_API_Helper.data_api_helper.fetchDara(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error is ${snapshot.error}"),
                      );
                    } else if (snapshot.hasData) {
                      (API_Data == [])
                          ? API_Data = snapshot.data as List<json_data>?
                          : null;

                      return DataTable(
                          sortColumnIndex: _isvalue2,
                          sortAscending: _isAsc2,
                          headingTextStyle:
                              TextStyle(fontSize: 25, color: Colors.green),
                          columns: [
                            DataColumn(
                              label: Text("ID"),
                              onSort: (columnIndex, _) {
                                _isvalue2 = columnIndex;
                                setState(() {
                                  if (_isAsc2) {
                                    API_Data!.sort(
                                      (a, b) => b.id!.compareTo(a.id!),
                                    );
                                  } else if (_isAsc2) {
                                    API_Data!.sort(
                                      (a, b) => a.id!.compareTo(b.id!),
                                    );
                                  }
                                  _isAsc2 = !_isAsc2;
                                });
                              },
                            ),
                            DataColumn(label: Text("NAME")),
                            DataColumn(label: Text("CITY")),
                            DataColumn(label: Text("STATE")),
                          ],
                          rows: API_Data!
                              .map((e) => DataRow(cells: [
                                    DataCell(Text("${e.id}")),
                                    DataCell(Text("${e.name}")),
                                    DataCell(Text("${e.location}")),
                                    DataCell(Text("${e.title}")),
                                  ]))
                              .toList());
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            )),
            SingleChildScrollView(
                child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                child: DataTable(
                    sortColumnIndex: _isvalue,
                    sortAscending: _isAsc,
                    headingTextStyle:
                        TextStyle(fontSize: 25, color: Colors.green),
                    columns: [
                      DataColumn(
                        label: Text("ID"),
                        onSort: (columnIndex, _) {
                          _isvalue = columnIndex;
                          setState(() {
                            if (_isAsc) {
                              Data.sort(
                                (a, b) => b.id!.compareTo(a.id!),
                              );
                            } else {
                              Data.sort(
                                (a, b) => a.id!.compareTo(b.id!),
                              );
                            }
                            _isAsc = !_isAsc;
                          });
                        },
                      ),
                      DataColumn(label: Text("NAME")),
                      DataColumn(label: Text("LOCTION")),
                      DataColumn(label: Text("TITLE")),
                    ],
                    rows: Data!
                        .map((e) => DataRow(
                              cells: [
                                DataCell(Text("${e.id}")),
                                DataCell(Text("${e.name}")),
                                DataCell(Text("${e.location}")),
                                DataCell(Text("${e.title}")),
                              ],
                              // selected: _selected[index],
                              // onSelectChanged: (bool? selected) {
                              // setState(() {
                              // _selected[index] = selected!;
                              // });
                              // }))
                              //     .toList();
                            ))
                        .toList()),
              ),
            ))
          ],
        ),
        alignment: Alignment.center,
      ),
    );
  }
}
