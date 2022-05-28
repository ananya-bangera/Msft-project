import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_advertising/pages/show_graphs.dart';


import 'classes.dart';
import 'list_of_videos.dart';

class DataAnalysis extends StatefulWidget {
  const DataAnalysis({Key? key}) : super(key: key);

  @override
  State<DataAnalysis> createState() => _DataAnalysisState();
}

class _DataAnalysisState extends State<DataAnalysis> {



  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    List<obj> names = [
      obj(name: 'Eatables',img: 'https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=80&raw_url=true&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170'),
      obj(name: 'Cosmetics',img: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1187&q=80'),
      obj(name: 'Footwear',img: 'https://images.unsplash.com/photo-1549971352-c31ced98e984?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=80&raw_url=true&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170'),
      obj(name: 'Watches',img: 'https://images.unsplash.com/photo-1535449425-adc6f5faa71c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1074&q=80'),
      obj(name: 'Phones',img: 'https://images.unsplash.com/photo-1556656793-08538906a9f8?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80'),
      obj(name: 'Books ',img: 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1122&q=80'),
      obj(name: 'Toys',img: 'https://images.unsplash.com/photo-1564429238817-393bd4286b2d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1074&q=80'),
      obj(name: 'Appliances',img: 'https://images.unsplash.com/photo-1583241475880-083f84372725?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80'),
    ];
    Widget advCard(String? category_name,String img) => Center(

      child:  Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0.5,
              child: Ink.image(
                image: NetworkImage(img),
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
                child: InkWell(

                  onTap: ()  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ListVideos(category_name: category_name))
                    );
                  },
                ),
                height: 150,
                fit: BoxFit.cover,
              ),
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
    // Widget advCard(String? category_name) =>  Center(
    //     child: Card(
    //       shadowColor: Colors.white,
    //       clipBehavior: Clip.antiAlias,
    //       shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(24)
    //       ),
    //       child: InkWell(
    //
    //         child: Container(
    //           width: width*0.9,
    //           color: Colors.grey,
    //           padding: const EdgeInsets.all(46.5),
    //           child: Center(
    //             child: Row(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Center(
    //                   child: CircleAvatar(
    //                     child:  Icon(Icons.food_bank_outlined),
    //                   ),
    //                 ),
    //                 const SizedBox(width: 15),
    //                 Column(
    //                   children: [
    //                     const SizedBox(width: 15),
    //                     Center(
    //                       child: Text(
    //                         "${category_name}",
    //                         style: TextStyle(
    //                             fontSize: 24,
    //                             fontWeight: FontWeight.bold),
    //                         ),
    //
    //                       ),
    //
    //                   ]
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     )
    // );

    return Scaffold(
        appBar: AppBar(
          title: Text("Analysis"),
          backgroundColor:Theme.of(context).appBarTheme.backgroundColor,),
      body:Scrollbar(
            child: Row(
              children: [
                SizedBox(width: 15,),
                SizedBox(
                  width: 180,
                  child: ListView.builder(
                      itemCount: names.length,
                      itemBuilder: (BuildContext context, int index) {
                        if(index%2==0) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              advCard(names[index].name, names[index++].img),
                            ],
                          );
                        }
                        return Container();
                      }
          ),
                ),
                SizedBox(
                  width: 180,
                  child: ListView.builder(
                      itemCount: names.length,
                      itemBuilder: (BuildContext context, int index) {
                        if(index%2==1) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              advCard(names[index].name, names[index++].img),
                            ],
                          );
                        }
                        return Container();
                      }
          ),
                ),

              ],
            )
       )
    );
  }

}
