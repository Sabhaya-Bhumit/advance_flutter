import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_service_app/global.dart';
import 'package:home_service_app/helper/firebase_auth_helper.dart';
import 'package:home_service_app/views/screens/admin_all_pages/Service_Update.dart';
import 'package:home_service_app/views/screens/admin_all_pages/admin_page.dart';
import 'package:home_service_app/views/screens/admin_all_pages/employee_add.dart';
import 'package:home_service_app/views/screens/admin_all_pages/service_add.dart';
import 'package:home_service_app/views/screens/intro_and_spelsh_screen/about_us_page.dart';
import 'package:home_service_app/views/screens/intro_and_spelsh_screen/contact_us_page.dart';
import 'package:home_service_app/views/screens/intro_and_spelsh_screen/intro_page.dart';
import 'package:home_service_app/views/screens/intro_and_spelsh_screen/splesh_screen.dart';
import 'package:home_service_app/views/screens/login_and_signUp/SignUp_page.dart';
import 'package:home_service_app/views/screens/login_and_signUp/login_page.dart';
import 'package:home_service_app/views/screens/user_all_pages/home.dart';
import 'package:home_service_app/views/screens/user_all_pages/worker_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences pres = await SharedPreferences.getInstance();
  global.remember = pres.getBool('remember') ?? false;

  bool istrue = pres.getBool('isskips') ?? false;
  pres.setBool('isskips', istrue);
  bool admin = false;
  add() async {
    User? user = await FirebaseAuthHelper.firebaseAuthHelper.currentUser();

    user?.uid;
    if (user?.uid == "h9laiHfTPuXWqwz99IITTD51Z0l2") {
      return true;
    } else {
      return false;
    }
  }

  await pres.setBool('remember', global.remember);
  runApp(
    MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.fromSwatch().copyWith()),
      debugShowCheckedModeBanner: false,
      initialRoute: (istrue == false) ? 'intro' : 'splesh_screen',
      routes: {
        '/': (context) => home(),
        'login_page': (context) => login_page(),
        'SignUp_page': (context) => SignUp_page(),
        'intro': (context) => intro(),
        'admin_page': (context) => admin_page(),
        'Service_Update': (context) => Service_Update(),
        'Service_Add': (context) => Service_Add(),
        'employee_add': (context) => employee_add(),
        'worker_detail': (context) => worker_detail(),
        'AboutUs_Page': (context) => AboutUs_Page(),
        'ContactUs_Page': (context) => ContactUs_Page(),
        'splesh_screen': (context) => splesh_screen(),
      },
    ),
  );
}
