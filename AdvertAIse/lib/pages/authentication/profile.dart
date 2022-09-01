import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../model/profile_widget.dart';

class Profile extends StatefulWidget {
  String? userType;
  Profile({Key? key, required this.userType}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _auth = FirebaseAuth.instance;

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
                    const SizedBox(height: 48),
                    buildAbout(),
                  ],
                );
              } else
                return Container();
            }));
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
            'About',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            ' ',
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
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
}
