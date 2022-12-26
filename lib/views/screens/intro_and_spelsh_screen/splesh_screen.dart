import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_service_app/global.dart';
import 'package:home_service_app/helper/firebase_auth_helper.dart';

class splesh_screen extends StatefulWidget {
  const splesh_screen({Key? key}) : super(key: key);

  @override
  State<splesh_screen> createState() => _splesh_screenState();
}

class _splesh_screenState extends State<splesh_screen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cal();
  }

  add() async {
    User? user = await FirebaseAuthHelper.firebaseAuthHelper.currentUser();

    user?.uid;
    if (user?.uid == "h9laiHfTPuXWqwz99IITTD51Z0l2") {
      return true;
    } else {
      return false;
    }
  }

  cal() async {
    await Future.delayed(Duration(seconds: 5), () async {
      Navigator.of(context).pushReplacementNamed(
        (global.remember)
            ? await (add())
                ? 'admin_page'
                : '/'
            : 'login_page',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: 50),
              CircleAvatar(
                  backgroundImage: AssetImage("assets/images/1.png"),
                  radius: 100),
              Text(
                "Log In Maker App",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              SizedBox(height: 50),
              SizedBox(height: 50),
              Text(
                "Welcome",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              CircularProgressIndicator(color: Colors.amberAccent)
            ],
          ),
        ),
      ),
    );
  }
}
