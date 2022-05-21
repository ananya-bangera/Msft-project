import 'package:flutter/material.dart';
import 'package:smart_advertising/pages/authenticationService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_advertising/pages/authenticationService.dart';
import 'package:smart_advertising/pages/home.dart';
import 'package:smart_advertising/pages/onboarding.dart';
import 'package:smart_advertising/pages/Classes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_advertising/pages/auth.dart';
import 'package:smart_advertising/pages/registeration.dart';
import 'package:smart_advertising/pages/video.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;
    // Categories
    List<obj> names = [
      obj(name: 'Food',icon: Icon(Icons.account_circle_outlined)),
      obj(name: 'Cosmetics',icon: Icon(Icons.h_mobiledata)),
      obj(name: 'Food',icon: Icon(Icons.account_circle_outlined)),
      obj(name: 'Food',icon: Icon(Icons.account_circle_outlined)),

    ];
    Widget advCard() =>  Center(
        child: Card(
          shadowColor: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24)
          ),
          child: InkWell(
            onTap: (){
              print("yes");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UploadVideo()),
              );
            },
            child: Container(
              width: width*0.45,
              color: Colors.grey,
              // decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //         colors: [
              //           Colors.pink,
              //           Colors.red
              //         ],
              //         begin: Alignment.topLeft,
              //         end: Alignment.bottomRight
              //     )
              // ),
              padding: const EdgeInsets.all(46.5),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      child:  Icon(Icons.food_bank_outlined),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Food",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    // const SizedBox(height: 15),
                    // Text(
                    //   "second",
                    //   style: TextStyle(fontSize: 24),
                    // ),
                  ],
                ),
              ),
            ),
          ),


        )
    );

    return Scaffold(

        appBar: AppBar(
          title: Text("Demo"),
          backgroundColor:Theme.of(context).appBarTheme.backgroundColor ,
          actions: [
            IconButton(
                onPressed: (){
                  logout(context);
                },
                icon: Icon(Icons.logout),
            )
          ],
        ),

        body: Stack(
          children: [
            Positioned(
              left:0,
              top:0,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        advCard(),
                        advCard()
                       ],
                    ),
                    Row(
                      children: [
                        advCard(),
                        advCard()
                      ],
                    ),
                  ],
                ),
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
                        size:Size(size.width,80),
                        painter: BNCustomPainter(),
                      ),
                      Center(
                        heightFactor: 0.6,
                        child: FloatingActionButton(onPressed: (){},
                        backgroundColor: Colors.orange,
                          child: Icon(Icons.analytics), elevation:0.1,),
                      ),
                      Container(
                        width: size.width,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:[
                            IconButton(
                              icon: Icon(Icons.home,color: Colors.black,),
                              onPressed: (){},
                            ),
                            IconButton(
                              icon: Icon(Icons.cloud_upload_outlined,color: Colors.black,),
                              onPressed: (){},
                            ),
                            Container(width: size.width*0.20,),
                            IconButton(
                              icon: Icon(Icons.analytics,color: Colors.black,),
                              onPressed: (){},
                            ),
                            IconButton(
                              icon: Icon(Icons.account_circle_outlined,color: Colors.black,),
                              onPressed: (){
                                context.read<AuthenticationService>().signOut();
                              },
                            ),


                          ]

                        ),
                      )
                    ],
                  ),
                )

            )
          ],
        ),

    );


  }

  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> SignInPage()));
  }
}
class BNCustomPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 20);
    path.quadraticBezierTo(size.width*.20, 0, size.width*0.35, 0);
    path.quadraticBezierTo(size.width*0.40, 0, size.width*0.40, 20);
    path.arcToPoint(Offset(size.width*0.60, 20),radius: Radius.circular(10.0),clockwise: false);
    path.quadraticBezierTo(size.width*0.60, 0, size.width*0.65, 0);
    path.quadraticBezierTo(size.width*0.80, 0, size.width, 20);
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
