class EmotionListModel {
  Map<String, String>? eml;

  EmotionListModel({this.eml});

  //Fetching data from server
  factory EmotionListModel.fromMap(map) {
    return EmotionListModel(eml: map['eml']);
  }

  //Sending Data to the server
  Map<String, dynamic> toMap() {
    return {'eml': eml};
  }
}
