import 'package:firebase_storage/firebase_storage.dart';

class VideoDataModel {
  final double score;
  final DateTime lastUpdated;
  final String? userName;

  VideoDataModel(
      {required this.score,
      required this.lastUpdated,
      this.userName = 'Anonymous'});

  //Fetching data from server
  factory VideoDataModel.fromMap(map) {
    return VideoDataModel(
        score: map['score'],
        lastUpdated: map['lastUpdated'],
        userName: map['userName']);
  }

  //Sending Data to the server
  Map<String, dynamic> toMap() {
    return {'score': score, 'lastUpdated': lastUpdated, 'userName': userName};
  }
}
