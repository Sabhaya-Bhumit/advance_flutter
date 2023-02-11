import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_management_2/views/screens/page1_page.dart';
import 'package:state_management_2/views/screens/page2_page.dart';

import 'views/screens/home_page.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/', page: () => home_page()),
        GetPage(name: '/page1', page: () => page1_page()),
        GetPage(name: '/page2', page: () => page2_page()),
      ],
    ),
  );
}
