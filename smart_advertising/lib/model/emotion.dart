class Emotion {
  String feelings;
  String timestamp;

  Emotion({required this.feelings, required this.timestamp});

  factory Emotion.fromMap(map) {
    return Emotion(
      feelings: map['feelings'],
      timestamp: map['timestamp'],
    );
  }

  //Sending Data to the server
  Map<String, dynamic> toMap() {
    return {
      '${timestamp}': feelings,
    };
  }
}
