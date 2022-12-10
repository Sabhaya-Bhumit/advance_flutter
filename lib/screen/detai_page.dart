import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_service_app/global.dart';
import 'package:screenshot/screenshot.dart';

class detail_page extends StatefulWidget {
  const detail_page({Key? key}) : super(key: key);

  @override
  State<detail_page> createState() => _detail_pageState();
}

int val = 0;
Uint8List? _imageFile;
ScreenshotController screenshotController = ScreenshotController();

class _detail_pageState extends State<detail_page> {
  @override
  void initState() {
    super.initState();
    val = 0;
  }

  @override
  Widget build(BuildContext context) {
    dynamic res = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          title: Text("$res"),
        ),
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            int i = 0;
            if (global.count1 == 0) {
              i = index;
            } else if (global.count1 == 1) {
              i = index;
            } else if (global.count1 == 2) {
              i = (index + 10);
            } else if (global.count1 == 3) {
              i = (index + 20);
            } else if (global.count1 == 4) {
              i = (index + 30);
            } else if (global.count1 == 5) {
              i = (index + 40);
            }

            print(i);
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              elevation: 15,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      global.count = [index, i];
                      Navigator.of(context).pushNamed('image_detail_page');
                    },
                    child: Container(
                      height: 450,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                            child: Image.network(
                              "${global.images![i + val].Image}",
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          Text("${global.quotes[i]}",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  overflow: TextOverflow.visible),
                              textAlign: TextAlign.center)
                        ],
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                              onTap: () {
                                setState(() {
                                  val++;
                                });
                              },
                              child: isRow(image: "assets/images/stcak.png")),
                          InkWell(
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: "${global.quotes[i]}"));
                              },
                              child: isRow(image: "assets/images/copy.png")),
                          InkWell(
                              onTap: () async {},
                              child: isRow(image: "assets/images/929539.png")),
                          InkWell(
                              onTap: () async {
                                //
                              },
                              child: isRow(image: "assets/images/downlod.png")),
                          InkWell(
                              onTap: () {},
                              child: isRow(image: "assets/images/star.png"))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }

  Widget isRow({required String image}) {
    return Image.asset("$image", width: 40);
  }
}
