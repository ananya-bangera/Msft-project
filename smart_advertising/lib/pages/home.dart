import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_advertising/pages/classes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_advertising/pages/auth.dart';
import 'package:smart_advertising/pages/profile.dart';
import 'package:smart_advertising/pages/upload_video.dart';
import 'about_us.dart';
import 'analysis.dart';
import 'display_video.dart';

class Home extends StatefulWidget {
  final String? value;

  const Home({Key? key, this.value}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    // Categories
    List<obj> names = [
      obj(
          name: 'Eatables',
          img:
              'https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=80&raw_url=true&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170'),
      obj(
          name: 'Cosmetics',
          img:
              'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1187&q=80'),
      obj(
          name: 'Footwear',
          img:
              'https://images.unsplash.com/photo-1549971352-c31ced98e984?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=80&raw_url=true&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170'),
      obj(
          name: 'Watches',
          img:
              'https://images.unsplash.com/photo-1535449425-adc6f5faa71c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1074&q=80'),
      obj(
          name: 'Phones',
          img:
              'https://images.unsplash.com/photo-1556656793-08538906a9f8?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80'),
      obj(
          name: 'Books',
          img:
              'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1122&q=80'),
      obj(
          name: 'Toys',
          img:
              'https://images.unsplash.com/photo-1564429238817-393bd4286b2d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1074&q=80'),
      obj(
          name: 'Appliances',
          img:
              'https://images.unsplash.com/photo-1583241475880-083f84372725?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80'),
    ];
    Widget advCard(String? category_name, String img) => Center(
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Ink.image(
                  image: NetworkImage(img),
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.3), BlendMode.dstATop),
                  child: InkWell(
                    onTap: () {
                      print(widget.value);
                      if (widget.value == "Company") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UploadVideo(category_name)),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DisplayVideo(category_name)),
                        );
                      }
                    },
                  ),
                  height: 150,
                  fit: BoxFit.cover,
                ),
                Center(
                  child: Text(
                    '${category_name}',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text("AdvertAIse"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Scrollbar(
              child: ListView.builder(
                  itemCount: names.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == names.length - 1) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          advCard(names[index].name, names[index].img),
                          SizedBox(
                            height: 80,
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          advCard(names[index].name, names[index].img),
                        ],
                      );
                    }
                  }),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: size.width,
                height: 80,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(size.width, 80),
                      painter: BNCustomPainter(),
                    ),
                    Center(
                      heightFactor: 0.6,
                      child: FloatingActionButton(
                        onPressed: () {
                          if (widget.value == "Company") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DataAnalysis()),
                            );
                          }
                        },
                        backgroundColor: Colors.orange,
                        child: Icon(Icons.analytics),
                        elevation: 0.1,
                      ),
                    ),
                    Container(
                      width: size.width,
                      height: 80,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.info,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AboutUs(),
                                ));
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.cloud_upload_outlined,
                                color: Colors.black,
                              ),
                              onPressed: () {},
                            ),
                            Container(
                              width: size.width * 0.20,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.home,
                                color: Colors.black,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.account_circle_outlined,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      Profile(userType: widget.value),
                                ));
                              },
                            ),
                          ]),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => SignInPage()));
  }
}

//For designing of Bottom Navigation
class BNCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 20);
    path.quadraticBezierTo(size.width * .20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(10.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
