import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
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
      obj(name: 'Food1',icon: Icon(Icons.account_circle_outlined)),
      obj(name: 'Cosmetics',icon: Icon(Icons.h_mobiledata)),
      obj(name: 'Food2',icon: Icon(Icons.account_circle_outlined)),
      obj(name: 'Food3',icon: Icon(Icons.account_circle_outlined)),
      obj(name: 'Food4',icon: Icon(Icons.account_circle_outlined)),
      obj(name: 'Food5',icon: Icon(Icons.account_circle_outlined)),
      obj(name: 'Food6',icon: Icon(Icons.account_circle_outlined)),
    ];

    Widget advCard(String? category_name) =>  Center(
        child: Card(
          shadowColor: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24)
          ),
          child: InkWell(
            onTap: ()  {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListVideos(category_name: category_name))
              );


            },
            child: Container(
              width: width*0.9,
              color: Colors.grey,
              padding: const EdgeInsets.all(46.5),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        child:  Icon(Icons.food_bank_outlined),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      children: [
                        const SizedBox(width: 15),
                        Center(
                          child: Text(
                            "${category_name}",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            ),

                          ),

                      ]
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );

    return Scaffold(
        appBar: AppBar(
          title: Text("Adv"),
          backgroundColor:Theme.of(context).appBarTheme.backgroundColor,),
      body:
          Scrollbar(
            child: ListView.builder(
                itemCount: names.length,
                itemBuilder: (BuildContext context, int index) {
                  return  advCard(names[index].name);
                }
            ),
          )


    );
  }

  // fetchData(){
  //    return FutureBuilder<DocumentSnapshot>(
  //     //Fetching data from the documentId specified of the student
  //     future: filesList.doc(_auth.currentUser?.email).get(),
  //     builder:
  //         (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
  //
  //
  //       //Error Handling conditions
  //       if (snapshot.hasError) {
  //          return Text("Something went wrong");
  //       }
  //
  //       if (snapshot.hasData && !snapshot.data!.exists) {
  //          return Text("Document does not exist");
  //       }
  //
  //       //Data is output to the user
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
  //          return drawPieChart(data);
  //       }
  //
  //        return Text("loading");
  //     },
  //   );
  //
  // }
  // drawPieChart(Map<String,dynamic> data){
  //   List<String> namesOfFiles =[];
  //   for(int i=0;i<data.length;i++){
  //     namesOfFiles.add(data[i]);
  //   }
  //   print(namesOfFiles);
  //   return Text(namesOfFiles.toString());
  //
  // }


}
