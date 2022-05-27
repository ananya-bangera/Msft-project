import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_advertising/pages/show_graphs.dart';



class ListVideos extends StatefulWidget {
  final String? category_name;
  const ListVideos({Key? key,required this.category_name}) : super(key: key);

  @override
  State<ListVideos> createState() => _ListVideosState();
}

class _ListVideosState extends State<ListVideos> {

  CollectionReference filesList = FirebaseFirestore.instance.collection("Uploads");
  final _auth = FirebaseAuth.instance;
  CollectionReference emotionsList = FirebaseFirestore.instance.collection("Emotions");
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.category_name}"),
          backgroundColor:Theme.of(context).appBarTheme.backgroundColor,
        ),
      body: Center(
        child: FutureBuilder<dynamic>(
          future: getData(widget.category_name),
          builder: (context, snapshot){
          if (snapshot.hasData) {

              return  ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: (){
                             Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ShowGraphs(category_name: widget.category_name,videoName: snapshot.data[index]))
                            );
                          },
                          child: Container(
                            height: 50,
                            // color: Colors.amber[colorCodes[index]],
                            child: Center(child: Text(snapshot.data[index].toString())),
                          ),
                        );
                      }
                  );
                }
          else{
            return CircularProgressIndicator();
          }
           }
        ),
      )
      // body: ListView.builder(
      //     padding: const EdgeInsets.all(8),
      //     itemCount: entries.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       return Container(
      //         height: 50,
      //         // color: Colors.amber[colorCodes[index]],
      //         child: Center(child: Text(entries[index].toString())),
      //       );
      //     }
      // ),
    );
  }
  getData(String? category_name) async {

    DocumentSnapshot snapshot = await filesList.doc(
        _auth.currentUser?.email.toString()).collection("categories").doc(
        category_name).get();
    var data = snapshot.data() as Map;
    List<String> videosList = [];
    data.keys.forEach((key) => videosList.add(key));
    return videosList;
    // Fluttertoast.showToast(msg: videosList.toString());

  }




}
