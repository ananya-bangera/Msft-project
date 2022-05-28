import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartAnalysis extends StatefulWidget {
  final String? category_name;
  final String? videoName;
  const PieChartAnalysis({Key? key,required this.category_name,required this.videoName}) : super(key: key);

  @override
  State<PieChartAnalysis> createState() => _PieChartAnalysisState();
}

class _PieChartAnalysisState extends State<PieChartAnalysis> {
  CollectionReference filesList = FirebaseFirestore.instance.collection("Uploads");
  final _auth = FirebaseAuth.instance;
  CollectionReference emotionsList = FirebaseFirestore.instance.collection("Emotions");

  @override
  Widget build(BuildContext context) {
    final gradientList = <List<Color>>[
      [
        Color.fromRGBO(223, 250, 92, 1),
        Color.fromRGBO(129, 250, 112, 1),
      ],
      [
        Color.fromRGBO(129, 182, 205, 1),
        Color.fromRGBO(91, 253, 199, 1),
      ],
      [
        Color.fromRGBO(175, 63, 62, 1.0),
        Color.fromRGBO(254, 154, 92, 1),
      ]
    ];
    return Scaffold(
        appBar: AppBar(
        title: Text("${widget.videoName}"),
    backgroundColor: Theme
        .of(context)
        .appBarTheme
        .backgroundColor,),
    body:Column(
      children: [
        SizedBox(height: 100.0,),
        FutureBuilder<dynamic>(
        future: drawPieChart(),
        builder: (context, snapshot) {
        if (snapshot.hasData) {
              return PieChart(
                      dataMap: snapshot.data,
                      animationDuration: Duration(milliseconds: 800),
                      chartLegendSpacing: 32,
                      chartRadius: MediaQuery
                          .of(context)
                          .size
                          .width / 2,
                      // colorList: [Colors.red,Colors.yellow,Colors.blue, Colors.green],
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 32,
                      centerText: "${widget.category_name}",
                      gradientList: gradientList,
                      emptyColorGradient: [
                        Color(0xff6c5ce7),
                        Colors.blue,
                      ],
                      legendOptions: LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: true,
                        // legendShape: _BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: false,
                        decimalPlaces: 1,
                      ),
                      // gradientList: ---To add gradient colors---
                      // emptyColorGradient: ---Empty Color gradient---
                    );
              }
            return CircularProgressIndicator();
            }
        ),
        SizedBox(height: 200,),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape:  new CircleBorder(),
                padding: EdgeInsets.all(10),
                primary: Colors.orange
            ),
            onPressed: (){
              Navigator.of(context).pop();

            },
            child:  Icon(Icons.navigate_before_rounded)
        ),

      ],
    )
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

  getEmotions(String? videoName) async {
    List<Map<String, dynamic>> list = [];
    List<String> videosList = await getData(widget.category_name);
    var allData;
    // CollectionReference collectionReference = await emotionsList.doc(
    //     videoName).collection("collection");
    // list.add(collectionReference);
    // Fluttertoast.showToast(msg: collectionReference.toString());
    CollectionReference collectionReference = await emotionsList.doc(
        videoName).collection("collection");
    QuerySnapshot querySnapshot = await collectionReference.get();
    // // Fluttertoast.showToast(msg:querySnapshot.docs.toString());
    // list.add(querySnapshot.docs.toString());
    //
    // Get data from docs and convert map to List
    // Fluttertoast.showToast(msg: querySnapshot.toString());
    querySnapshot.docs.map((doc) => print(doc));
    // print(allData);
    print(collectionReference);

    for (final doc in querySnapshot.docs) {
      final obj_dummy = doc.data();
      list.add(Map.from(obj_dummy as Map<String, dynamic>)['eml']);

    }
    return list;
  }

  drawPieChart() async {
    final listPieChart = await getEmotions(widget.videoName);
    Map<String,double> dataMap ={
      "Angry":0,
      "Sad":0,
      "Happy":0,
      "Neutral":0
    };
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    print("--------------------------------------------------------------------------------------");
    for(final lpc in listPieChart){
      print(lpc.toString()+":");

      print(lpc.keys);
      for(final emt in lpc.values ){
        print(emt);
        dataMap[emt] = (dataMap[emt]!+1);
      }
    }
    return dataMap;
  }
}
