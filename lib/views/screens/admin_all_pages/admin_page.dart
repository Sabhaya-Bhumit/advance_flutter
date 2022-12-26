import 'package:flutter/material.dart';
import 'package:home_service_app/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/firebase_auth_helper.dart';

class admin_page extends StatefulWidget {
  const admin_page({Key? key}) : super(key: key);

  @override
  State<admin_page> createState() => _admin_pageState();
}

class _admin_pageState extends State<admin_page> {
  @override
  Widget build(BuildContext context) {
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
          title: Text("Admin"),
          centerTitle: true,
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
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('Service_Update', arguments: 1);
                  },
                  child: Text("Service UpDate and delete")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('Service_Update', arguments: 2);
                  },
                  child: Text("Employee UpDate and delete")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('Service_Add');
                  },
                  child: Text("Service Add")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('employee_add', arguments: 4);
                  },
                  child: Text("Employee Add")),
            ],
          ),
        ),
      ),
    );
  }
}
