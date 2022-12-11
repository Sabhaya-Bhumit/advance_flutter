import 'dart:math';

import 'package:demo/global.dart';
import 'package:demo/helpers/image_api.dart';
import 'package:demo/screen/detail_page.dart';
import 'package:demo/screen/home.dart';
import 'package:demo/screen/image_screen.dart';
import 'package:demo/screen/splace_Screen.dart';
import 'package:flutter/material.dart';

Random random = Random();
void main() async {
  int i = random.nextInt(7);
  global.Images = await Image_api.image_api
      .feach_Data(Animal_name: "${global.Animal_name[i]['name']}");
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'splace_Screen',
      routes: {
        '/': (context) => home(),
        'detail_page': (context) => detail_page(),
        'image_detail_page': (context) => image_detail_page(),
        'splace_Screen': (context) => splace_Screen(),
      },
    ),
  );
}
