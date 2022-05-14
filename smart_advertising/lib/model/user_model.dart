class  UserModel{
  String? uid;
  String? email;
  String? firstName;
  String? surName;
  UserModel({ this.uid, this.email, this.firstName, this.surName});

  //Fetching data from server
  factory UserModel.fromMap(map){
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        surName: map['surName'],
    );
  }

  //Sending Data to the server
  Map<String,dynamic> toMap(){
    return {
      'uid':uid,
      'email':email,
      'firstName':firstName,
      'surName':surName,
    };
  }

}