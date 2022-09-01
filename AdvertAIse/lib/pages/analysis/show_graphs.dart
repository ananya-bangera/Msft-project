import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:advertaise/pages/analysis/pie_chart.dart';

class ShowGraphs extends StatefulWidget {
  final String? category_name;
  final String? videoName;

  const ShowGraphs(
      {Key? key, required this.category_name, required this.videoName})
      : super(key: key);

  @override
  State<ShowGraphs> createState() => _ShowGraphsState();
}

class _ShowGraphsState extends State<ShowGraphs> {
  late int showingTooltip;
  CollectionReference filesList =
      FirebaseFirestore.instance.collection("Uploads");
  final _auth = FirebaseAuth.instance;
  CollectionReference emotionsList =
      FirebaseFirestore.instance.collection("Emotions");

  // green==> happy
  // yellow ==> sad
  // red ==> angry
  // blue ==> neutral

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    const double barWidth = 22;
    const shadowOpacity = 0.2;
    int touchedIndex = -1;

    @override
    void initState() {
      showingTooltip = -1;
      super.initState();
    }

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
                const Color(0xfffc0707),
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
                const Color(0xff2bdb90),
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
                  const Color(0xfffc0707).withOpacity(
                      isTouched ? shadowOpacity * 2 : shadowOpacity),
                  const BorderSide(color: Colors.transparent)),
              BarChartRodStackItem(
                  -value1,
                  -(value1 + value2),
                  const Color(0xffffdd80).withOpacity(
                      isTouched ? shadowOpacity * 2 : shadowOpacity),
                  const BorderSide(color: Colors.transparent)),
              BarChartRodStackItem(
                  -(value1 + value2),
                  -(value1 + value2 + value3),
                  const Color(0xff2bdb90).withOpacity(
                      isTouched ? shadowOpacity * 2 : shadowOpacity),
                  const BorderSide(color: Colors.transparent)),
              BarChartRodStackItem(
                  -(value1 + value2 + value3),
                  -(value1 + value2 + value3 + value4),
                  const Color(0xff19bfff).withOpacity(
                      isTouched ? shadowOpacity * 2 : shadowOpacity),
                  const BorderSide(color: Colors.transparent)),
            ],
          ),
        ],
      );
    }

    bool isShadowBar(int rodIndex) => rodIndex == 1;
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.videoName}"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<dynamic>(
                future: drawLineChart(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 0.8,
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                                color: const Color(0xff020227),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: BarChart(
                                    BarChartData(
                                      alignment: BarChartAlignment.center,
                                      minY: 0,
                                      groupsSpace: 12,
                                      barTouchData: BarTouchData(
                                        touchTooltipData: BarTouchTooltipData(),
                                        handleBuiltInTouches: false,
                                        touchCallback: (FlTouchEvent event,
                                            barTouchResponse) {
                                          if (!event
                                                  .isInterestedForInteractions ||
                                              barTouchResponse == null ||
                                              barTouchResponse.spot == null) {
                                            setState(() {
                                              touchedIndex = -1;
                                            });
                                            return;
                                          }
                                          final rodIndex = barTouchResponse
                                              .spot!.touchedRodDataIndex;
                                          if (isShadowBar(rodIndex)) {
                                            setState(() {
                                              touchedIndex = -1;
                                            });
                                            return;
                                          }
                                          setState(() {
                                            touchedIndex = barTouchResponse
                                                .spot!.touchedBarGroupIndex;
                                          });
                                        },
                                      ),
                                      titlesData: FlTitlesData(
                                        show: true,
                                        topTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 32,
                                          ),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 32,
                                          ),
                                        ),
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            interval: 5,
                                            reservedSize: 42,
                                          ),
                                        ),
                                        rightTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            interval: 5,
                                            reservedSize: 42,
                                          ),
                                        ),
                                      ),
                                      gridData: FlGridData(
                                        show: true,
                                        checkToShowHorizontalLine: (value) =>
                                            value % 5 == 0,
                                        getDrawingHorizontalLine: (value) {
                                          if (value == 0) {
                                            return FlLine(
                                                color: const Color(0xff363753),
                                                strokeWidth: 3);
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
                                      barGroups: Map.from(snapshot.data
                                              as Map<int, List<double>>)
                                          .entries
                                          .map((e) => generateGroup(
                                              e.key,
                                              e.value[0],
                                              e.value[1],
                                              e.value[2],
                                              e.value[3]))
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return CircularProgressIndicator();
                }),
          ),
          Text("Timestamps"),
          SizedBox(
            child: Column(
              children: [
                Pallete("Happy", Color(0xff2bdb90)),
                SizedBox(
                  height: 10,
                ),
                Pallete("Sad", Color(0xffffdd80)),
                SizedBox(
                  height: 10,
                ),
                Pallete("Angry", Colors.red),
                SizedBox(
                  height: 10,
                ),
                Pallete("Neutral", Color(0xff19bfff)),
              ],
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: new CircleBorder(),
                  padding: EdgeInsets.all(10),
                  primary: Colors.orange),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PieChartAnalysis(
                          category_name: widget.category_name,
                          videoName: widget.videoName)),
                );
              },
              child: Icon(Icons.navigate_next_rounded)),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  //For drawing the labels
  Widget Pallete(String feelings, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 20,
        ),
        ColoredBox(
          color: color,
          child: SizedBox(
            width: 20,
            height: 20,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text("${feelings}")
      ],
    );
  }

  //To get videos List associated with a specific company under a particular category
  getData(String? category_name) async {
    DocumentSnapshot snapshot = await filesList
        .doc(_auth.currentUser?.email.toString())
        .collection("categories")
        .doc(category_name)
        .get();
    var data = snapshot.data() as Map;
    List<String> videosList = [];
    data.keys.forEach((key) => videosList.add(key));
    return videosList;
  }

  //To get emotions associated with a particular video
  getEmotions(String? videoName) async {
    List<Map<String, dynamic>> list = [];
    CollectionReference collectionReference =
        await emotionsList.doc(videoName).collection("collection");
    QuerySnapshot querySnapshot = await collectionReference.get();
    for (final doc in querySnapshot.docs) {
      final obj_dummy = doc.data();
      list.add(Map.from(obj_dummy as Map<String, dynamic>)['eml']);
    }
    return list;
  }

  //To draw a pie chart
  drawPieChart() async {
    final listPieChart = await getEmotions(widget.videoName);
    Map<String, double> dataMap = {
      "Angry": 0,
      "Sad": 0,
      "Happy": 0,
      "Neutral": 0
    };

    for (final lpc in listPieChart) {
      for (final emt in lpc.keys) {
        dataMap[emt] = (dataMap[emt]! + 1);
      }
    }
    return dataMap;
  }

  //To draw a line chart
  drawLineChart() async {
    final listLineChart = await getEmotions(widget.videoName);
    Map<int, List<double>> dataMapLine = {};
    for (final llc in listLineChart) {
      for (final timestampKeys in llc.keys) {
        dataMapLine.addEntries([
          MapEntry(int.parse(timestampKeys), [0.0, 0.0, 0.0, 0.0])
        ]);
      }
    }
    for (final llc in listLineChart) {
      for (final timestampKeys in llc.keys) {
        if (llc[timestampKeys] == "Angry") {
          dataMapLine[int.parse(timestampKeys)]?[0]++;
        } else if (llc[timestampKeys] == "Sad") {
          dataMapLine[int.parse(timestampKeys)]?[1]++;
        } else if (llc[timestampKeys] == "Happy") {
          dataMapLine[int.parse(timestampKeys)]?[2]++;
        } else if (llc[timestampKeys] == "Neutral") {
          dataMapLine[int.parse(timestampKeys)]?[3]++;
        }
      }
    }
    return dataMapLine;
  }
}
