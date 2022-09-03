import 'package:advertaise/model/participant.dart';
import 'package:advertaise/model/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:advertaise/pages/leaderboard/winner_container.dart';
import 'package:advertaise/pages/leaderboard/contestant_list.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  List<String> dataList = [];
  List<ParticipantModel> participants = [];
  List<String?> namesList = [];
  final _fireStore = FirebaseFirestore.instance.collection("Watched");
  @override
  void initState() {
    getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: myColors.calculatorScreen,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("AdvertAIse"),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          leading: Icon(Icons.arrow_back_ios, color: Colors.white),
          actions: [Icon(Icons.grid_view, color: Colors.white)],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: LinearGradient(colors: [
                      Colors.yellow.shade600,
                      Colors.orange,
                      Colors.red
                    ]),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: myColors.calculatorButton),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Region',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0),
                            ),
                            Text(
                              'National',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0),
                            ),
                            Text(
                              'Global',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      WinnerContainer(
                        isFirst: false,
                        color: Colors.green,
                        winnerPosition: '2',
                        winnerName: (namesList.length > 2)
                            ? namesList[1].toString()
                            : 'None',
                        rank: '2',
                        height: 120.0,
                        url: 'assets/user.png',
                      ),
                      WinnerContainer(
                        isFirst: true,
                        color: Colors.orange,
                        winnerPosition: '1',
                        winnerName: (namesList.length > 2)
                            ? namesList[0].toString()
                            : 'None',
                        rank: '1',
                        height: 150.0,
                        url: 'assets/user.png',
                      ),
                      //
                      WinnerContainer(
                        isFirst: false,
                        color: Colors.blue,
                        winnerPosition: '3',
                        winnerName: (namesList.length > 2)
                            ? namesList[2].toString()
                            : 'None',
                        rank: '3',
                        height: 120.0,
                        url: 'assets/user.png',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.yellow.shade600,
                      Colors.orange,
                      Colors.red
                    ]),
                    border: Border.all(
                      color: Colors.amber,
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: 350.0,
                      decoration: BoxDecoration(
                        color: myColors.calculatorScreen,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0)),
                      ),
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: namesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (index > 2)
                              return ContestantList(
                                url: 'assets/user.png',
                                name: '${namesList[index]}',
                                rank: '${index + 1}',
                              );
                            else
                              return Container();
                          }),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getDetails() async {
    // FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference collectionReference = await _fireStore;
    QuerySnapshot querySnapshot = await collectionReference.get();
    // print(querySnapshot.docs.length);
    for (final doc in querySnapshot.docs) {
      dataList.add(doc.id.toString());
    }
    for (var dataItem in dataList) {
      await collectionReference
          .doc(dataItem)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          ParticipantModel participantModel = ParticipantModel(
              score: double.parse(data['score'].toString()),
              lastUpdated: DateTime.now(),
              userName: data['userName'].toString());
          participants.add(participantModel);
        } else {
          print('Document does not exist on the database');
        }
      });
    }
    participants.sort((a, b) => (b.score.compareTo(a.score)));

    for (var participant in participants) {
      namesList.add(participant.userName);
    }
    setState(() {});
    return namesList;
  }
}
