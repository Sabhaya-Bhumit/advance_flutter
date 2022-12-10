import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:home_service_app/global.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class image_detail_page extends StatefulWidget {
  const image_detail_page({Key? key}) : super(key: key);

  @override
  State<image_detail_page> createState() => _image_detail_pageState();
}

int i = 0;
ScreenshotController screenshotController = ScreenshotController();

class _image_detail_pageState extends State<image_detail_page> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    i = 0;
  }

  @override
  Widget build(BuildContext context) {
    double _heght = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Screenshot(
          controller: screenshotController,
          child: Container(
            color: Colors.blueAccent,
            height: _heght,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  "${global.images![global.count[0] + i].Image}",
                  height: double.infinity,
                  fit: BoxFit.fitHeight,
                ),
                Text("${global.quotes[global.count[1]]}",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        overflow: TextOverflow.visible),
                    textAlign: TextAlign.center)
              ],
            ),
          ),
        ),
        Container(
          height: 50,
          width: double.infinity,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      i++;
                    });
                  },
                  child: isRow(image: "assets/images/stcak.png")),
              InkWell(
                  onTap: () {}, child: isRow(image: "assets/images/copy.png")),
              InkWell(
                  onTap: () async {
                    final image = await screenshotController.capture();
                    if (image == null) return;

                    await saveImage(image);
                    saveAndShare(image);
                  },
                  child: isRow(image: "assets/images/929539.png")),
              InkWell(
                  onTap: () async {
                    final image = await screenshotController.capture();
                    if (image == null) return;

                    await saveImage(image);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Image Is Save In Album"),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                    ));
                  },
                  child: isRow(image: "assets/images/downlod.png")),
              InkWell(
                  onTap: () {}, child: isRow(image: "assets/images/star.png"))
            ],
          ),
        ),
      ],
    ));
  }

  Widget isRow({required String image}) {
    return Image.asset("$image", width: 40);
  }

  Future saveAndShare(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytesSync(bytes);
    await Share.shareFiles([image.path]);
  }

  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '_')
        .replaceAll(':', '_');
    final name = "screenshot_$time";
    final result = await ImageGallerySaver.saveImage(bytes, name: name);

    return result['filePath'];
  }
}
