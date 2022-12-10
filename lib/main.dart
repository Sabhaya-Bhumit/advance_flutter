import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:home_service_app/global.dart';
import 'package:home_service_app/helper/qoute_db.dart';
import 'package:home_service_app/helper/quote_api.dart';
import 'package:home_service_app/modal/quote_modal.dart';
import 'package:home_service_app/screen/detai_page.dart';
import 'package:home_service_app/screen/image_detail_page.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screen/home.dart';

bool connection = true;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prep = await SharedPreferences.getInstance();

  connection = await InternetConnectionChecker().hasConnection;

  log(connection.toString(), name: "Connection");
  global.isData = prep.getBool('isData') ?? false;
  prep.setBool('isData', global.isData);

  if (connection == true) {
    await QuoteDatabaseHelper.quoteDatabaseHelper.deleteAllData();
    // await ImageDatabaseHelper.imageDatabaseHelper.deleteAllData();

    List<Quotes>? allQuotes =
        await QuotesAPIHelper.quotesAPIHelper.fetchQuotes();
    // List<myImages>? allImages = await ImageAPIHelper.imageAPIHelper.fetchImages();

    await QuoteDatabaseHelper.quoteDatabaseHelper
        .insertData(allQuotes: allQuotes);
    // await ImageDatabaseHelper.imageDatabaseHelper.insertData(allImages: allImages);
  } else {
    List<Quotes> quotes =
        await QuoteDatabaseHelper.quoteDatabaseHelper.fetchAllData();
    // List<myImages> images = await ImageDatabaseHelper.imageDatabaseHelper.fetchAllData();

    // log(images.toString(),name: "Images");
    log(quotes.toString(), name: "Quotes");
  }

  List<String> quotes = [];
  quoteData() async {
    List<Quotes> data =
        await QuoteDatabaseHelper.quoteDatabaseHelper.fetchAllData();
    for (int i = 0; i < data.length; i++) {
      global.quotes.add(data[i].quote);
    }
  }

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => home(),
        'detail_Page': (context) => detail_page(),
        'image_detail_page': (context) => image_detail_page(),
      },
    ),
  );
}
