import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_service_app/global.dart';
import 'package:home_service_app/helper/image_api.dart';
import 'package:home_service_app/helper/qoute_db.dart';
import 'package:home_service_app/modal/quote_modal.dart';
// import 'package:home_service_app/helper/image_apimodal.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quoteData();
  }

  quoteData() async {
    List<Quotes> data =
        await QuoteDatabaseHelper.quoteDatabaseHelper.fetchAllData();

    for (int i = 0; i < data.length; i++) {
      global.quotes.add(data[i].quote);
    }
    global.quotes.addAll(global.loveQuotes);
    global.quotes.addAll(global.learningQuotes);
    global.quotes.addAll(global.motivationalQuotes);
    global.quotes.addAll(global.truthQuotes);
  }

  int initvalue = 0;
  CarouselController carouselController = CarouselController();
  List cate = ["Categories", "Pic Qoutes", "Latest Qoutes", "Articles"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text("Life Quotes and Sayin...."),
        actions: [
          Image.asset("assets/images/notification.png", width: 35),
          SizedBox(width: 8),
          Image.asset("assets/images/heart.png", width: 35),
          SizedBox(width: 8)
        ],
      ),
      body: FutureBuilder(
        future: Image_api.image_api.feach_Data(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("error is = ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            global.images = snapshot.data;

            return Container(
                height: double.infinity,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarouselSlider(
                          carouselController: carouselController,
                          items: [
                            Container(
                                alignment: Alignment.center,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.network("${global.images![8].Image}",
                                        width: 600, fit: BoxFit.cover),
                                    Text(
                                      textAlign: TextAlign.center,
                                      "${global.quotes[5]}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.visible),
                                    )
                                  ],
                                )),
                            Container(
                                alignment: Alignment.center,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.network("${global.images![10].Image}",
                                        width: 600, fit: BoxFit.cover),
                                    Text(
                                      textAlign: TextAlign.center,
                                      "${global.quotes[6]}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.visible),
                                    )
                                  ],
                                )),
                            Container(
                                alignment: Alignment.center,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.network("${global.images![15].Image}",
                                        width: 600, fit: BoxFit.cover),
                                    Text(
                                      textAlign: TextAlign.center,
                                      "${global.quotes[7]}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.visible),
                                    )
                                  ],
                                )),
                            Container(
                                alignment: Alignment.center,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.network("${global.images![14].Image}",
                                        width: 600, fit: BoxFit.cover),
                                    Text(
                                      textAlign: TextAlign.center,
                                      "${global.quotes[8]}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.visible),
                                    )
                                  ],
                                )),
                            Container(
                                alignment: Alignment.center,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.network("${global.images![16].Image}",
                                        width: 600, fit: BoxFit.cover),
                                    Text(
                                      textAlign: TextAlign.center,
                                      "${global.quotes[9]}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.visible),
                                    )
                                  ],
                                )),
                          ],
                          options: CarouselOptions(
                              height: 200,
                              autoPlay: true,
                              aspectRatio: 0.8,
                              enlargeCenterPage: true,
                              initialPage: initvalue,
                              onPageChanged: (val, _) {
                                setState(() {
                                  initvalue = val;
                                });
                              },
                              autoPlayCurve: Curves.decelerate)),

                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(10)),
                            child: Image.asset("assets/images/category.png",
                                width: 35, color: Colors.white),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(10)),
                            child: Image.asset("assets/images/gallery.png",
                                width: 35, color: Colors.white),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(10)),
                            child: Image.asset("assets/images/cogwheel.png",
                                width: 35, color: Colors.white),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(10)),
                            child: Image.asset("assets/images/open-book.png",
                                width: 35, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: cate
                              .map((e) => Text("$e",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)))
                              .toList()),
                      SizedBox(height: 20),
                      Text("   Most Popular",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      //most
                      Container(
                          height: 380,
                          width: double.infinity,
                          child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.all(10),
                            itemCount: global.QouteName.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            itemBuilder: (context, index) {
                              int i = index;
                              i += 5;
                              return Column(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        global.count1 = index;

                                        Navigator.of(context).pushNamed(
                                            'detail_Page',
                                            arguments: global.QouteName[index]);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                    "${global.images![index].Image}"))),
                                      ),
                                    ),
                                    flex: 5,
                                  ),
                                  Expanded(
                                    child: Text("${global.QouteName[index]}",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 25)),
                                    flex: 1,
                                  )
                                ],
                              );
                            },
                          )),
                      SizedBox(height: 20),
                      //Quotes by authors

                      Text("    Quotes by Authors",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),

                      SizedBox(height: 20),
                      Container(
                          height: 500,
                          width: double.infinity,
                          child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.all(10),
                            itemCount: global.QouteName.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 20),
                            itemBuilder: (context, index) {
                              return InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "${global.QouteName[index]}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                ),
                                onTap: () {
                                  global.count1 = index;

                                  Navigator.of(context).pushNamed('detail_Page',
                                      arguments: global.QouteName[index]);
                                },
                              );
                            },
                          )),
                    ],
                  ),
                ));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      drawer: Drawer(
          child: Column(
        children: [
          Expanded(
              child: Container(
                alignment: Alignment.center,
                color: Colors.blueAccent.shade700,
                child: Text(
                  "Life Qoutes And Sayings",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style:
                      GoogleFonts.artifika(fontSize: 30, color: Colors.white),
                ),
              ),
              flex: 4),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {},
                    child: isRow(
                        image: "assets/images/topic.png", name: "By Topic"),
                  ),
                  SizedBox(height: 15),
                  isRow(image: "assets/images/writer.png", name: "By Author"),
                  SizedBox(height: 15),
                  isRow(image: "assets/images/star.png", name: "Favorites"),
                  SizedBox(height: 15),
                  isRow(
                      image: "assets/images/idea.png",
                      name: "Qoute of the Day"),
                  SizedBox(height: 15),
                  isRow(
                      image: "assets/images/star.png",
                      name: "Favorites Pictures"),
                  SizedBox(height: 15),
                  isRow(image: "assets/images/1384060.png", name: "Videos"),
                  SizedBox(height: 10),
                  Divider(thickness: 2, color: Colors.grey),
                  Text(
                    "     Communicate",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  SizedBox(height: 15),
                  isRow(image: "assets/images/cogwheel.png", name: "Settings"),
                  SizedBox(height: 20),
                  isRow(image: "assets/images/929539.png", name: "Share"),
                  SizedBox(height: 20),
                  isRow(image: "assets/images/732042.png", name: "Rate"),
                  SizedBox(height: 20),
                  isRow(image: "assets/images/546394.png", name: "FeedBcak"),
                  SizedBox(height: 20),
                  isRow(
                      image: "assets/images/117453.png",
                      name: "Our Other apps"),
                  SizedBox(height: 15),
                  isRow(image: "assets/images/3503827.png", name: "About"),
                ],
              ),
              flex: 10),
        ],
      )),
    );
  }

  Widget isRow({required String image, required String name}) {
    return Row(
      children: [
        SizedBox(width: 20),
        Image.asset("$image", width: 30),
        SizedBox(width: 10),
        Text(
          "$name",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
