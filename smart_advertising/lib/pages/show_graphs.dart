import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smart_advertising/pages/pie_chart.dart';
import 'indicator.dart';
import 'package:fl_chart/src/chart/pie_chart/pie_chart.dart';


class ShowGraphsCopy extends StatefulWidget {
  final String? category_name;
  final String? videoName;
  const ShowGraphsCopy( {Key? key, required this.category_name, required this.videoName}) : super(key: key);

  @override
  State<ShowGraphsCopy> createState() => _ShowGraphsCopyState();
}

class _ShowGraphsCopyState extends State<ShowGraphsCopy> {
  CollectionReference filesList = FirebaseFirestore.instance.collection(
      "Uploads");
  final _auth = FirebaseAuth.instance;
  CollectionReference emotionsList = FirebaseFirestore.instance.collection(
      "Emotions");


  // green==> happy
  // yellow ==> sad
  // pink ==> angry
  // blue ==> neutral

  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    const double barWidth = 22;
    const shadowOpacity = 0.2;
    int touchedIndex = -1;

    @override
    void initState() {
      super.initState();
    }

    // Widget bottomTitles(double value, TitleMeta meta) {
    //   const style = TextStyle(color: Colors.white, fontSize: 10);
    //   String text;
    //   switch (value.toInt()) {
    //     case 0:
    //       text = 'Mon';
    //       break;
    //     case 1:
    //       text = 'Tue';
    //       break;
    //     case 2:
    //       text = 'Wed';
    //       break;
    //     case 3:
    //       text = 'Thu';
    //       break;
    //     case 4:
    //       text = 'Fri';
    //       break;
    //     case 5:
    //       text = 'Sat';
    //       break;
    //     case 6:
    //       text = 'Sun';
    //       break;
    //     default:
    //       text = '';
    //       break;
    //   }
    //   return SideTitleWidget(
    //     child: Text(text, style: style),
    //     axisSide: meta.axisSide,
    //   );
    // }
    //
    // Widget topTitles(double value, TitleMeta meta) {
    //   const style = TextStyle(color: Colors.white, fontSize: 10);
    //   String text;
    //   switch (value.toInt()) {
    //     case 0:
    //       text = 'Mon';
    //       break;
    //     case 1:
    //       text = 'Tue';
    //       break;
    //     case 2:
    //       text = 'Wed';
    //       break;
    //     case 3:
    //       text = 'Thu';
    //       break;
    //     case 4:
    //       text = 'Fri';
    //       break;
    //     case 5:
    //       text = 'Sat';
    //       break;
    //     case 6:
    //       text = 'Sun';
    //       break;
    //     default:
    //       return Container();
    //   }
    //   return SideTitleWidget(
    //     child: Text(text, style: style),
    //     axisSide: meta.axisSide,
    //   );
    // }
    //
    // Widget leftTitles(double value, TitleMeta meta) {
    //   const style = TextStyle(color: Colors.white, fontSize: 10);
    //   String text;
    //   if (value == 0) {
    //     text = '0';
    //   } else {
    //     text = '${value.toInt()}0k';
    //   }
    //   return SideTitleWidget(
    //     angle: AppUtils().degreeToRadian(value < 0 ? -45 : 45),
    //     axisSide: meta.axisSide,
    //     space: 4.0,
    //     child: Text(
    //       text,
    //       style: style,
    //       textAlign: TextAlign.center,
    //     ),
    //   );
    // }
    //
    // Widget rightTitles(double value, TitleMeta meta) {
    //   const style = TextStyle(color: Colors.white, fontSize: 10);
    //   String text;
    //   if (value == 0) {
    //     text = '0';
    //   } else {
    //     text = '${value.toInt()}0k';
    //   }
    //   return SideTitleWidget(
    //     angle: AppUtils().degreeToRadian(90),
    //     axisSide: meta.axisSide,
    //     space: 0,
    //     child: Text(
    //       text,
    //       style: style,
    //       textAlign: TextAlign.center,
    //     ),
    //   );
    // }

    BarChartGroupData generateGroup(
        int x,
        double value1,
        double value2,
        double value3,
        double value4,
        ) {
      bool isTop = value1 > 0;
      final sum = value1 + value2 + value3 + value4;
      final isTouched = touchedIndex == x;
      return BarChartGroupData(
        x: x,
        groupVertically: true,
        showingTooltipIndicators: isTouched ? [0] : [],
        barRods: [
          BarChartRodData(
            toY: sum,
            width: barWidth,
            borderRadius: isTop
                ? const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            )
                : const BorderRadius.only(
              bottomLeft: Radius.circular(6),
              bottomRight: Radius.circular(6),
            ),
            rodStackItems: [
              BarChartRodStackItem(
                0,
                value1,
                const Color(0xff2bdb90),
                BorderSide(
                  color: Colors.white,
                  width: isTouched ? 2 : 0,
                ),
              ),
              BarChartRodStackItem(
                value1,
                value1 + value2,
                const Color(0xffffdd80),
                BorderSide(
                  color: Colors.white,
                  width: isTouched ? 2 : 0,
                ),
              ),
              BarChartRodStackItem(
                value1 + value2,
                value1 + value2 + value3,
                const Color(0xffff4d94),
                BorderSide(
                  color: Colors.white,
                  width: isTouched ? 2 : 0,
                ),
              ),
              BarChartRodStackItem(
                value1 + value2 + value3,
                value1 + value2 + value3 + value4,
                const Color(0xff19bfff),
                BorderSide(
                  color: Colors.white,
                  width: isTouched ? 2 : 0,
                ),
              ),
            ],
          ),
          BarChartRodData(
            toY: -sum,
            width: barWidth,
            color: Colors.transparent,
            borderRadius: isTop
                ? const BorderRadius.only(
              bottomLeft: Radius.circular(6),
              bottomRight: Radius.circular(6),
            )
                : const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            rodStackItems: [
              BarChartRodStackItem(
                  0,
                  -value1,
                  const Color(0xff2bdb90)
                      .withOpacity(isTouched ? shadowOpacity * 2 : shadowOpacity),
                  const BorderSide(color: Colors.transparent)),
              BarChartRodStackItem(
                  -value1,
                  -(value1 + value2),
                  const Color(0xffffdd80)
                      .withOpacity(isTouched ? shadowOpacity * 2 : shadowOpacity),
                  const BorderSide(color: Colors.transparent)),
              BarChartRodStackItem(
                  -(value1 + value2),
                  -(value1 + value2 + value3),
                  const Color(0xffff4d94)
                      .withOpacity(isTouched ? shadowOpacity * 2 : shadowOpacity),
                  const BorderSide(color: Colors.transparent)),
              BarChartRodStackItem(
                  -(value1 + value2 + value3),
                  -(value1 + value2 + value3 + value4),
                  const Color(0xff19bfff)
                      .withOpacity(isTouched ? shadowOpacity * 2 : shadowOpacity),
                  const BorderSide(color: Colors.transparent)),
            ],
          ),
        ],
      );
    }

    bool isShadowBar(int rodIndex) => rodIndex == 1;




    return Scaffold(
      appBar: AppBar(
        title: Text("Adv"),
        backgroundColor: Theme
            .of(context)
            .appBarTheme
            .backgroundColor,),
      body: Column(
        children: [
          // FutureBuilder<dynamic>(
          // future: drawPieChart(),
          // builder: (context, snapshot) {
          // if (snapshot.hasData) {
          //       return PieChart(
          //               dataMap: snapshot.data,
          //               animationDuration: Duration(milliseconds: 800),
          //               chartLegendSpacing: 32,
          //               chartRadius: MediaQuery
          //                   .of(context)
          //                   .size
          //                   .width / 3.2,
          //               // colorList: [Colors.red,Colors.yellow,Colors.blue, Colors.green],
          //               initialAngleInDegree: 0,
          //               chartType: ChartType.ring,
          //               ringStrokeWidth: 32,
          //               centerText: "HYBRID",
          //               gradientList: gradientList,
          //               emptyColorGradient: [
          //                 Color(0xff6c5ce7),
          //                 Colors.blue,
          //               ],
          //               legendOptions: LegendOptions(
          //                 showLegendsInRow: false,
          //                 legendPosition: LegendPosition.right,
          //                 showLegends: true,
          //                 // legendShape: _BoxShape.circle,
          //                 legendTextStyle: TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               chartValuesOptions: ChartValuesOptions(
          //                 showChartValueBackground: true,
          //                 showChartValues: true,
          //                 showChartValuesInPercentage: false,
          //                 showChartValuesOutside: false,
          //                 decimalPlaces: 1,
          //               ),
          //               // gradientList: ---To add gradient colors---
          //               // emptyColorGradient: ---Empty Color gradient---
          //             );
          //       }
          //     return CircularProgressIndicator();
          //     }
          // ),

          // Expanded(
          //     child:FutureBuilder(
          //     future: drawPieChart(),
          //     builder: (context, snapshot) {
          //       if (snapshot.hasData) {
          //         return AspectRatio(
          //           aspectRatio: 1.3,
          //           child: Card(
          //             color: Colors.white,
          //             child: Row(
          //               children: <Widget>[
          //                 const SizedBox(
          //                   height: 18,
          //                 ),
          //                 Expanded(
          //                   child: AspectRatio(
          //                     aspectRatio: 1,
          //                     child: PieChart(
          //                       PieChartData(
          //
          //                           pieTouchData: PieTouchData(touchCallback:
          //                               (FlTouchEvent event, pieTouchResponse) {
          //                             setState(() {
          //                               if (!event.isInterestedForInteractions ||
          //                                   pieTouchResponse == null ||
          //                                   pieTouchResponse.touchedSection == null) {
          //                                 touchedIndex = -1;
          //                                 return;
          //                               }
          //                               touchedIndex = pieTouchResponse
          //                                   .touchedSection!.touchedSectionIndex;
          //                             });
          //                           }),
          //                           borderData: FlBorderData(
          //                             show: false,
          //                           ),
          //                           sectionsSpace: 0,
          //                           centerSpaceRadius: 40,
          //                           sections:  widget.mp,
          //
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 Column(
          //                   mainAxisSize: MainAxisSize.max,
          //                   mainAxisAlignment: MainAxisAlignment.end,
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: const <Widget>[
          //                     Indicator(
          //                       color: Color(0xff0293ee),
          //                       text: 'First',
          //                       isSquare: true,
          //                     ),
          //                     SizedBox(
          //                       height: 4,
          //                     ),
          //                     Indicator(
          //                       color: Color(0xfff8b250),
          //                       text: 'Second',
          //                       isSquare: true,
          //                     ),
          //                     SizedBox(
          //                       height: 4,
          //                     ),
          //                     Indicator(
          //                       color: Color(0xff845bef),
          //                       text: 'Third',
          //                       isSquare: true,
          //                     ),
          //                     SizedBox(
          //                       height: 4,
          //                     ),
          //                     Indicator(
          //                       color: Color(0xff13d38e),
          //                       text: 'Fourth',
          //                       isSquare: true,
          //                     ),
          //                     SizedBox(
          //                       height: 18,
          //                     ),
          //                   ],
          //                 ),
          //                 const SizedBox(
          //                   width: 28,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         );
          //       }
          //
          //       return Container();
          //     })),
          Expanded(
            child: FutureBuilder<dynamic>(
                future: drawLineChart(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 0.8,
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            color: const Color(0xff020227),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.center,
                                  maxY: 20,
                                  minY: -20,
                                  groupsSpace: 12,
                                  barTouchData: BarTouchData(
                                    handleBuiltInTouches: false,
                                    touchCallback: (FlTouchEvent event, barTouchResponse) {
                                      if (!event.isInterestedForInteractions ||
                                          barTouchResponse == null ||
                                          barTouchResponse.spot == null) {
                                        setState(() {
                                          touchedIndex = -1;
                                        });
                                        return;
                                      }
                                      final rodIndex = barTouchResponse.spot!.touchedRodDataIndex;
                                      if (isShadowBar(rodIndex)) {
                                        setState(() {
                                          touchedIndex = -1;
                                        });
                                        return;
                                      }
                                      setState(() {
                                        touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                                      });
                                    },
                                  ),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 32,
                                        // getTitlesWidget: topTitles,
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 32,
                                        // getTitlesWidget: bottomTitles,
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        // getTitlesWidget: leftTitles,
                                        interval: 5,
                                        reservedSize: 42,
                                      ),
                                    ),
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        // getTitlesWidget: rightTitles,
                                        interval: 5,
                                        reservedSize: 42,
                                      ),
                                    ),
                                  ),
                                  gridData: FlGridData(
                                    show: true,
                                    checkToShowHorizontalLine: (value) => value % 5 == 0,
                                    getDrawingHorizontalLine: (value) {
                                      if (value == 0) {
                                        return FlLine(
                                            color: const Color(0xff363753), strokeWidth: 3);
                                      }
                                      return FlLine(
                                        color: const Color(0xff2a2747),
                                        strokeWidth: 0.8,
                                      );
                                    },
                                  ),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  barGroups: Map.from(snapshot.data as Map<int,List<double>>).entries
                                      .map((e) => generateGroup(
                                      e.key, e.value[0], e.value[1], e.value[2], e.value[3]))
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        )
                        // LineChart(
                        //   LineChartData(
                        //
                        //   ),
                        // )

                        // PieChart(
                        // snapshot.data,
                        // swapAnimationDuration: Duration(milliseconds: 150), // Optional
                        // swapAnimationCurve: Curves.linear, // Optional
                        // ),
                        // PieChart(
                        //   dataMap: snapshot.data,
                        //   animationDuration: Duration(milliseconds: 800),
                        //   chartLegendSpacing: 32,
                        //   chartRadius: MediaQuery.of(context).size.width / 3.2,
                        //   // colorList: [Colors.red,Colors.yellow,Colors.blue, Colors.green],
                        //   initialAngleInDegree: 0,
                        //   chartType: ChartType.ring,
                        //   ringStrokeWidth: 32,
                        //   centerText: "HYBRID",
                        //   gradientList: gradientList,
                        //   emptyColorGradient: [
                        //     Color(0xff6c5ce7),
                        //     Colors.blue,
                        //   ],
                        //   legendOptions: LegendOptions(
                        //     showLegendsInRow: false,
                        //     legendPosition: LegendPosition.right,
                        //     showLegends: true,
                        //     // legendShape: _BoxShape.circle,
                        //     legendTextStyle: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        //   chartValuesOptions: ChartValuesOptions(
                        //     showChartValueBackground: true,
                        //     showChartValues: true,
                        //     showChartValuesInPercentage: false,
                        //     showChartValuesOutside: false,
                        //     decimalPlaces: 1,
                        //   ),
                        //   // gradientList: ---To add gradient colors---
                        //   // emptyColorGradient: ---Empty Color gradient---
                        // ),
                      ],
                    );
                  }
                  return CircularProgressIndicator();
                }
            ),
          ),
          IconButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PieChartAnalysis(category_name: widget.category_name,videoName: widget.videoName)),
                );

              },
              icon:  Icon(Icons.navigate_next_rounded)
          )
        ],
      ),
    );
  }

  // Future<List<PieChartSectionData>> showingSections() async {
  //   Map<String, double> mp = await drawPieChart();
  //   final double totalEmotions =  mp["0 Angry"]! + mp["1 Sad"]!+mp["2 Happy"]! + mp["3 Neutral"]!;
  //   return List.generate(4, (i) {
  //     final isTouched = i == touchedIndex;
  //     final fontSize = isTouched ? 25.0 : 16.0;
  //     final radius = isTouched ? 60.0 : 50.0;
  //     switch (i) {
  //       case 0:
  //         return PieChartSectionData(
  //           color: const Color(0xff0293ee),
  //           value: 100*(mp["0 Angry"]!/totalEmotions),
  //           title: '${100*(mp["0 Angry"]!/totalEmotions)}%',
  //           radius: radius,
  //           titleStyle: TextStyle(
  //               fontSize: fontSize,
  //               fontWeight: FontWeight.bold,
  //               color: const Color(0xffffffff)),
  //         );
  //       case 1:
  //         return PieChartSectionData(
  //           color: const Color(0xfff8b250),
  //           value: 100*(mp["1 Sad"]!/totalEmotions),
  //           title: '${100*(mp["1 Sad"]!/totalEmotions)}%',
  //           radius: radius,
  //           titleStyle: TextStyle(
  //               fontSize: fontSize,
  //               fontWeight: FontWeight.bold,
  //               color: const Color(0xffffffff)),
  //         );
  //       case 2:
  //         return PieChartSectionData(
  //           color: const Color(0xff845bef),
  //           value: 100*(mp["2 Happy"]!/totalEmotions),
  //           title: '${100*(mp["2 Happy"]!/totalEmotions)}%',
  //           radius: radius,
  //           titleStyle: TextStyle(
  //               fontSize: fontSize,
  //               fontWeight: FontWeight.bold,
  //               color: const Color(0xffffffff)),
  //         );
  //       case 3:
  //         return PieChartSectionData(
  //           color: const Color(0xff13d38e),
  //           value: 100*(mp["3 Neutral"]!/totalEmotions),
  //           title: '${100*(mp["3 Neutral"]!/totalEmotions)}%',
  //           radius: radius,
  //           titleStyle: TextStyle(
  //               fontSize: fontSize,
  //               fontWeight: FontWeight.bold,
  //               color: const Color(0xffffffff)),
  //         );
  //       default:
  //         throw Error();
  //     }
  //   });
  // }

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
  // static const double barWidth = 22;
  // static const shadowOpacity = 0.2;
  // static const mainItems = <int, List<double>>{
  //   0: [2, 3, 2.5, 8],
  //   1: [-1.8, -2.7, -3, -6.5],
  //   2: [1.5, 2, 3.5, 6],
  //   3: [1.5, 1.5, 4, 6.5],
  //   4: [-2, -2, -5, -9],
  //   5: [-1.2, -1.5, -4.3, -10],
  //   6: [1.2, 4.8, 5, 5],
  // };
  // int touchedIndex = -1;



  // BarChartGroupData generateGroup(
  //     int x,
  //     double value1,
  //     double value2,
  //     double value3,
  //     double value4,
  //     ) {
  //   bool isTop = value1 > 0;
  //   final sum = value1 + value2 + value3 + value4;
  //   final isTouched = touchedIndex == x;
  //   return BarChartGroupData(
  //     x: x,
  //     groupVertically: true,
  //     showingTooltipIndicators: isTouched ? [0] : [],
  //     barRods: [
  //       BarChartRodData(
  //         toY: sum,
  //         width: barWidth,
  //         borderRadius: isTop
  //             ? const BorderRadius.only(
  //           topLeft: Radius.circular(6),
  //           topRight: Radius.circular(6),
  //         )
  //             : const BorderRadius.only(
  //           bottomLeft: Radius.circular(6),
  //           bottomRight: Radius.circular(6),
  //         ),
  //         rodStackItems: [
  //           BarChartRodStackItem(
  //             0,
  //             value1,
  //             const Color(0xff2bdb90),
  //             BorderSide(
  //               color: Colors.white,
  //               width: isTouched ? 2 : 0,
  //             ),
  //           ),
  //           BarChartRodStackItem(
  //             value1,
  //             value1 + value2,
  //             const Color(0xffffdd80),
  //             BorderSide(
  //               color: Colors.white,
  //               width: isTouched ? 2 : 0,
  //             ),
  //           ),
  //           BarChartRodStackItem(
  //             value1 + value2,
  //             value1 + value2 + value3,
  //             const Color(0xffff4d94),
  //             BorderSide(
  //               color: Colors.white,
  //               width: isTouched ? 2 : 0,
  //             ),
  //           ),
  //           BarChartRodStackItem(
  //             value1 + value2 + value3,
  //             value1 + value2 + value3 + value4,
  //             const Color(0xff19bfff),
  //             BorderSide(
  //               color: Colors.white,
  //               width: isTouched ? 2 : 0,
  //             ),
  //           ),
  //         ],
  //       ),
  //       BarChartRodData(
  //         toY: -sum,
  //         width: barWidth,
  //         color: Colors.transparent,
  //         borderRadius: isTop
  //             ? const BorderRadius.only(
  //           bottomLeft: Radius.circular(6),
  //           bottomRight: Radius.circular(6),
  //         )
  //             : const BorderRadius.only(
  //           topLeft: Radius.circular(6),
  //           topRight: Radius.circular(6),
  //         ),
  //         rodStackItems: [
  //           BarChartRodStackItem(
  //               0,
  //               -value1,
  //               const Color(0xff2bdb90)
  //                   .withOpacity(isTouched ? shadowOpacity * 2 : shadowOpacity),
  //               const BorderSide(color: Colors.transparent)),
  //           BarChartRodStackItem(
  //               -value1,
  //               -(value1 + value2),
  //               const Color(0xffffdd80)
  //                   .withOpacity(isTouched ? shadowOpacity * 2 : shadowOpacity),
  //               const BorderSide(color: Colors.transparent)),
  //           BarChartRodStackItem(
  //               -(value1 + value2),
  //               -(value1 + value2 + value3),
  //               const Color(0xffff4d94)
  //                   .withOpacity(isTouched ? shadowOpacity * 2 : shadowOpacity),
  //               const BorderSide(color: Colors.transparent)),
  //           BarChartRodStackItem(
  //               -(value1 + value2 + value3),
  //               -(value1 + value2 + value3 + value4),
  //               const Color(0xff19bfff)
  //                   .withOpacity(isTouched ? shadowOpacity * 2 : shadowOpacity),
  //               const BorderSide(color: Colors.transparent)),
  //         ],
  //       ),
  //     ],
  //   );
  // }
  //
  // bool isShadowBar(int rodIndex) => rodIndex == 1;



  drawPieChart() async {
    final listPieChart = await getEmotions(widget.videoName);
    Map<String,double> dataMap ={
      "0 Angry":0,
      "1 Sad":0,
      "2 Happy":0,
      "3 Neutral":0
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

      print(lpc);
      for(final emt in lpc.keys ){
        print(emt);
        dataMap[emt] = (dataMap[emt]!+1);
      }
    }
    return dataMap;
  }
  drawLineChart() async{

    final listLineChart = await getEmotions(widget.videoName);
    Map<int ,List<double>>dataMapLine={}; //timestamp: [a,s,..]
    for(final llc in listLineChart) {
      for(final timestampKeys in llc.keys){
        print(timestampKeys.toString());
        // print(llc.keys(timestampKeys));
        dataMapLine.addEntries(
            [
              MapEntry(int.parse(timestampKeys), [0.0,0.0,0.0,0.0])
            ]
        );
        print(dataMapLine);
      }
    }
    for(final llc in listLineChart){
      print(llc.toString()+":");
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
      print("--------------------------------------------------------------------------------------");
      print("--------------------------------------------------------------------------------------");
      print("--------------------------------------------------------------------------------------");
      print("--------------------------------------------------------------------------------------");
      print(llc);
      // List<String> timeStamKeyList = llc.keys.sort(intmyComparator);

      for(final timestampKeys in llc.keys){
        if(llc[timestampKeys]=="0 Angry")
        {
          dataMapLine[int.parse(timestampKeys)]?[0]++;
        }
        else if(llc[timestampKeys]=="1 Sad")
        {
          dataMapLine[int.parse(timestampKeys)]?[1]++;
        }
        else if(llc[timestampKeys]=="2 Happy")
        {
          dataMapLine[int.parse(timestampKeys)]?[2]++;
        }
        else if(llc[timestampKeys]=="3 Neutral")
        {
          dataMapLine[int.parse(timestampKeys)]?[3]++;
        }

      }


    }
    // print(dataMapLine.runtimeType);
    // print(Map.from(dataMapLine as Map<int,List<double>>).runtimeType);
    // final Map<int,List<double>>return_list = Map.from(dataMapLine as Map<int,List<double>>);
    // print(return_list.runtimeType);
    // print(return_list.entries.map((e) => print(e.runtimeType)));
    return dataMapLine;

  }


}

