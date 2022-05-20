class  UserModel{
  String? uid;
  String? email;
  String? firstName;
  String? surName;
  String? userType;

  UserModel({ this.uid, this.email, this.firstName, this.surName, this.userType});

  //Fetching data from server
  factory UserModel.fromMap(map){
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        surName: map['surName'],
        userType: map['userType']
    );
  }

  //Sending Data to the server
  Map<String,dynamic> toMap(){
    return {
      'uid':uid,
      'email':email,
      'firstName':firstName,
      'surName':surName,
      'userType':userType
    };
  }

}