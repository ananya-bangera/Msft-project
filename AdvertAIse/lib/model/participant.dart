class ParticipantModel {
  final double score;
  final DateTime lastUpdated;
  final String? userName;

  ParticipantModel(
      {required this.score,
      required this.lastUpdated,
      this.userName = 'Anonymous'});

  //Fetching data from server
  factory ParticipantModel.fromMap(map) {
    return ParticipantModel(
        score: map['score'],
        lastUpdated: map['lastUpdated'],
        userName: map['userName']);
  }

  //Sending Data to the server
  Map<String, dynamic> toMap() {
    return {'score': score, 'lastUpdated': lastUpdated, 'userName': userName};
  }
}
