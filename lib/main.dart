import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: home(),
    ),
  );
}

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(""), centerTitle: true),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 10),
              CustomPaint(
                foregroundPainter: painter(),
                child: Container(
                  width: 300,
                  height: 350,
                  color: Colors.yellow,
                ),
                painter: painter(),
              ),
              SizedBox(height: 10),
              ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child:
                      Container(height: 250, width: 250, color: Colors.black)),
              SizedBox(height: 20),
              ClipOval(
                  child:
                      Container(height: 250, width: 150, color: Colors.green)),
              ClipPath(
                clipper: mycliper(),
                child: Container(height: 350, width: 350, color: Colors.pink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class mycliper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.quadraticBezierTo(
        size.width * 0.25, size.height * 0.65, size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint bursh = Paint();
    Paint bursh2 = Paint();

    bursh.color = Colors.black;
    bursh.style = PaintingStyle.fill;
    bursh.strokeWidth = 5;
    Path path = Path();
    bursh2.color = Colors.redAccent;
    bursh2.style = PaintingStyle.fill;
    bursh2.strokeWidth = 5;
    Path path2 = Path();
    path.moveTo(0, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.5,
        size.width * 0.5, size.height * 0.7);
    path.quadraticBezierTo(
        size.width * 0.85, size.height * 0.9, size.width, size.height * 0.7);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    path2.moveTo(0, size.height * 0.5);
    path2.quadraticBezierTo(size.width * 0.25, size.height * 0.25,
        size.width * 0.5, size.height * 0.5);
    path2.quadraticBezierTo(
        size.width * 0.75, size.height * 0.25, size.width, size.height * 0.5);
    path2.close();
    canvas.drawPath(path2, bursh2);

    canvas.drawPath(path, bursh);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint\
    return false;
  }
}
