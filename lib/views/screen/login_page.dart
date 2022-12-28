import 'package:firebace_app/helper/fcm_notification_helper.dart';
import 'package:firebace_app/helper/firebase_auth_helper.dart';
import 'package:firebace_app/helper/local_notification_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

class login_page extends StatefulWidget with WidgetsBindingObserver {
  const login_page({Key? key}) : super(key: key);

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> with WidgetsBindingObserver {
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? email;
  String? password;

  Future<void> getToken() async {
    String? token =
        await Firebase_MessageHelper.firebase_message.getFCMDeviceToken();
    print("============================================");
    print(token);
    print("============================================");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    //FCM Notifincation
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("Notification arrived in foreground");

      print("Notification Title : ${message.notification!.title}");
      print("Notification Title : ${message.notification!.body}");

      print("Data : ${message.data}");

      await LocalNotificationHelper.localNotificationHelper
          .sendSimpleNotication(id: 1);
    });
    //End of FCM Notifincation

    //local notification start
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
    //local notifincation end
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
    return Scaffold(
      appBar: AppBar(title: Text(" login_page Page")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () async {
                await LocalNotificationHelper.localNotificationHelper
                    .sendSimpleNotication(id: 1);
              },
              child: Text("Simpl Notification")),
          ElevatedButton(
              onPressed: () async {
                await LocalNotificationHelper.localNotificationHelper
                    .sendScheduleNotifincation(id: 1);
              },
              child: Text("Schedule Notifincation")),
          ElevatedButton(
              onPressed: () async {
                await LocalNotificationHelper.localNotificationHelper
                    .sendBigPictureNotifications();
              },
              child: Text("Big Picture Notifications")),
          ElevatedButton(
              onPressed: () async {
                await LocalNotificationHelper.localNotificationHelper
                    .sendMediaNotification();
              },
              child: Text("Media Notification")),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                User? user = await FirebaseAuthHelper.firebaseAuthHelper
                    .logInAnonymously();
                if (user != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("LogIn Sucessfull..."),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ));
                  Navigator.of(context)
                      .pushReplacementNamed('/', arguments: user);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("LogIn failed..."),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ));
                }
              },
              child: Text("anonnymous Sing In")),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: singUp, child: Text("Sing Up")),
              ElevatedButton(onPressed: singIn, child: Text("Sing In")),
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                User? user = await FirebaseAuthHelper.firebaseAuthHelper
                    .singInWithGoogle();

                if (user != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("LogIn Sucessfull..."),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ));
                  Navigator.of(context)
                      .pushReplacementNamed('/', arguments: user);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("LogIn failed..."),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ));
                }
              },
              child: Text("Sing In With Google")),
        ],
      ),
    );
  }

  singUp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text("Sign Up"),
          content: Form(
            key: signUpFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Email"),
                      hintText: "Enter You E mail Address"),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter You Email Address";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    email = val;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Password"),
                      hintText: "Enter You PassWord "),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter You PassWord";
                    } else if (val.length <= 6) {
                      return "Enter You Long PassWord Up to 6 char";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    password = val;
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          if (signUpFormKey.currentState!.validate()) {
                            signUpFormKey.currentState!.save();

                            try {
                              User? user = await FirebaseAuthHelper
                                  .firebaseAuthHelper
                                  .signUpUser(
                                      email: email!, password: password!);

                              if (user != null) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("LogIn Sucessfull..."),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                ));

                                // Navigator.of(context).pushReplacementNamed('/');
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Sign Up failed..."),
                                  backgroundColor: Colors.redAccent,
                                  behavior: SnackBarBehavior.floating,
                                ));
                              }
                            } on FirebaseAuthException catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("${e.message}"),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                              ));

                              // switch (e.code) {
                              //   case "email-already-in-use":
                              //     ScaffoldMessenger.of(context)
                              //         .showSnackBar(SnackBar(
                              //       content:
                              //           Text("This User Is Already Exists"),
                              //       backgroundColor: Colors.redAccent,
                              //       behavior: SnackBarBehavior.fixed,
                              //     ));
                              //     break;
                              //   case "weak-password":
                              //     ScaffoldMessenger.of(context)
                              //         .showSnackBar(SnackBar(
                              //       content: Text(
                              //           "Password Must Be At Least 6 Cahracters Or Long"),
                              //       backgroundColor: Colors.redAccent,
                              //       behavior: SnackBarBehavior.fixed,
                              //     ));
                              //     break;
                              //   case "invalid-email":
                              //     ScaffoldMessenger.of(context)
                              //         .showSnackBar(SnackBar(
                              //       content: Text("Email Id Is Not Valid"),
                              //       backgroundColor: Colors.redAccent,
                              //       behavior: SnackBarBehavior.fixed,
                              //     ));
                              //     break;
                              // }
                              Navigator.of(context).pop();
                            }
                            emailController.clear();
                            passwordController.clear();
                            email = null;
                            password = null;
                          }
                        },
                        child: Text("Sing Up")),
                    OutlinedButton(
                        onPressed: () {
                          emailController.clear();
                          passwordController.clear();
                          email = null;
                          password = null;

                          Navigator.of(context).pop();
                        },
                        child: Text("Cancal"))
                  ],
                )
              ],
            ),
          )),
    );
  }

  singIn() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text("Sign In"),
          content: Form(
            key: signInFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Email"),
                      hintText: "Enter You E mail Address"),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter You Email Address";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    email = val;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Password"),
                      hintText: "Enter You PassWord "),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter You PassWord";
                    } else if (val.length <= 6) {
                      return "Enter You Long PassWord Up to 6 char";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    password = val;
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          if (signInFormKey.currentState!.validate()) {
                            signInFormKey.currentState!.save();

                            try {
                              User? user = await FirebaseAuthHelper
                                  .firebaseAuthHelper
                                  .signInUser(
                                      email: email!, password: password!);

                              if (user != null) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("LogIn Sucessfull..."),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                ));

                                Navigator.of(context)
                                    .pushReplacementNamed('/', arguments: user);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Sign In failed..."),
                                  backgroundColor: Colors.redAccent,
                                  behavior: SnackBarBehavior.floating,
                                ));
                              }
                            } on FirebaseAuthException catch (e) {
                              print("============");
                              print(e);
                              switch (e.code) {
                                case "wrong-password":
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text("Password Is Wroge"),
                                    backgroundColor: Colors.redAccent,
                                    behavior: SnackBarBehavior.fixed,
                                  ));
                                  break;
                                case "user-not-found":
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text("Email Is Not Valid"),
                                    backgroundColor: Colors.redAccent,
                                    behavior: SnackBarBehavior.fixed,
                                  ));
                                  break;
                                case "user-disabled":
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "You Account Is Disabled By Authentication"),
                                    backgroundColor: Colors.redAccent,
                                    behavior: SnackBarBehavior.fixed,
                                  ));
                                  break;
                                case "invalid-email":
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text("Email Id Is Not Valid"),
                                    backgroundColor: Colors.redAccent,
                                    behavior: SnackBarBehavior.fixed,
                                  ));
                                  break;
                              }
                              Navigator.of(context).pop();
                            }

                            emailController.clear();
                            passwordController.clear();
                            email = null;
                            password = null;
                          }
                        },
                        child: Text("Sing In")),
                    OutlinedButton(
                        onPressed: () {
                          emailController.clear();
                          passwordController.clear();
                          email = null;
                          password = null;

                          // Navigator.of(context).pop();
                        },
                        child: Text("Cancal"))
                  ],
                )
              ],
            ),
          )),
    );
  }
}
