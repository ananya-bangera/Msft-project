import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../model/participant.dart';
import '../../model/profile_widget.dart';
import 'package:advertaise/model/themes.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

class Profile extends StatefulWidget {
  String? userType;
  Profile({Key? key, required this.userType}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var user = FirebaseAuth.instance.currentUser;
  final _auth = FirebaseAuth.instance;
  List<String> songsList = [];
  List<String> dataList = [];
  List<ParticipantModel> participants = [];
  List<String?> namesList = [];
  final _fireStore = FirebaseFirestore.instance.collection("Watched");

  var heart = Emoji('heart', '❤️');
  var heartEmoji = EmojiParser().emojify(':heart:');
  int rank = 0;
  @override
  void initState() {
    getSongDetails();
    getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    return Scaffold(
        appBar: AppBar(
          title: Text("AdvertAIse"),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),
        body: FutureBuilder<dynamic>(
            future: getUser(user),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    SizedBox(height: 50),
                    ProfileWidget(
                      imagePath:
                          'https://images.unsplash.com/photo-1574182245530-967d9b3831af?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=437&q=80',
                      onClicked: () async {},
                    ),
                    const SizedBox(height: 24),
                    buildName(snapshot.data['firstName'],
                        snapshot.data['surName'], snapshot.data['email']),
                    const SizedBox(height: 24),
                    Center(child: buildUpgradeButton()),
                    const SizedBox(height: 24),
                    rankOfUser(),
                    const SizedBox(height: 24),
                    buildAbout(),
                    watchedVideo(),
                  ],
                );
              } else
                return Container();
            }));
  }

  Widget rankOfUser() {
    return Padding(
      padding: const EdgeInsets.only(left: 120, right: 50),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
        ),
        child: Row(
          children: [
            Text(
              'Rank: ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: myColors.calculatorScreen,
                    borderRadius: BorderRadius.circular(40.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    rank.toString(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget watchedVideo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              height: 250.0,
              decoration: BoxDecoration(
                  color: myColors.calculatorScreen,
                  borderRadius: BorderRadius.circular(40.0)),
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: songsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: myColors.calculatorButton,
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 20.0),
                          child: Text(
                            songsList[index].toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildName(String firstName, String surName, String userEmail) {
    return Column(
      children: [
        Text(
          '${firstName} ${surName}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          '${userEmail}',
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  Widget buildUpgradeButton() {
    return ElevatedButton(
      child: Text('Upgrade To PRO'),
      onPressed: () {},
    );
  }

  Widget buildAbout() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Watched Videos',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Text(
          //   ' ',
          //   style: TextStyle(fontSize: 16, height: 1.4),
          // ),
        ],
      ),
    );
  }

  getUser(User? user) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('${widget.userType}')
        .doc('${user?.uid}')
        .get();
    return Map.from(snapshot.data() as Map<String, dynamic>);
  }

  //To get list of songs viewed by the user
  void getSongDetails() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("Viewed")
          .doc("${user.email}")
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          for (var data_song in data['songs']) {
            songsList.add(data_song);
          }
        } else {
          print('Document does not exist on the database');
        }
      });
      setState(() {});
    }
  }

  // To generate the rank-wise list and rank
  getDetails() async {
    var user = FirebaseAuth.instance.currentUser;
    CollectionReference collectionReference = await _fireStore;
    QuerySnapshot querySnapshot = await collectionReference.get();
    String name = "";
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
          if (user != null && dataItem == user.email) {
            name = data['userName'].toString();
          }
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
    final index = namesList.indexWhere((element) => element == name);
    rank = index + 1;
    setState(() {});
  }
}
