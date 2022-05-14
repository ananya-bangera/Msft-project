import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_advertising/model/user_model.dart';
import 'package:smart_advertising/pages/home.dart';

class RegisterationScreen extends StatefulWidget {
  const RegisterationScreen({Key? key}) : super(key: key);

  @override
  State<RegisterationScreen> createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {

  //Firebase
  final _auth = FirebaseAuth.instance;

  //form key
  final _formKey = GlobalKey<FormState>();

  //Editing Controllers
  final firstNameEditingController = new TextEditingController();
  final surNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();


  @override
  Widget build(BuildContext context) {

    //First Name
    final firstnameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
        validator: (value) {

          if (value!.isEmpty) {
            return ("First Name cant be empty");
          }

        },
      onSaved: (value){
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle_outlined),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "First Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ));

    //Second Name
    final surnameField = TextFormField(
      autofocus: false,
      controller: surNameEditingController,
      keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return (" SurName cant be empty");
          }
        },
      onSaved: (value){
        surNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle_outlined),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Second Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ));

    //Email Field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value){
        emailEditingController.text = value!;
      },
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }

          //reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(
              value)) {
            return ("Please Enter a Valid Email");
          }
          return null;
        },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ));

    //Password Field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password (Min 6 Character)");
        }
      },
      onSaved: (value){
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key_outlined),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ));

    //Confirm Field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value)
        {

          if(passwordEditingController.text!=confirmPasswordEditingController.text){
            return ("Password Doesn't Match");
          }
          return null;
        },
      onSaved: (value){
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key_outlined),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ));

    //Signup Button
    final signUpButton = Material(
      elevation:5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: (){
          SignUp(emailEditingController.text,passwordEditingController.text);
        },
        child: Text(
              "Login",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold
              )
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Demo"),
        backgroundColor:Theme.of(context).appBarTheme.backgroundColor ,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(

            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 200,
                      child: Image.asset('assets/welcome.png',width: 350,),
                    ),
                    SizedBox(height: 20,),
                    firstnameField,
                    SizedBox(height: 20,),
                    surnameField,
                    SizedBox(height: 20,),
                    emailField,
                    SizedBox(height: 20,),
                    passwordField,
                    SizedBox(height: 20,),
                    confirmPasswordField,
                    SizedBox(height: 20,),
                    signUpButton,
                    SizedBox(height: 20,),
                 ],
                ),
              ),
            )
          ),
        ),
      ),
    );
  }
  void SignUp(String email, String password) async{
    if(_formKey.currentState!.validate()){
        await _auth.createUserWithEmailAndPassword(email: email, password: password)
       .then((value)=>{
          postDetailsToFirestore()
        }).catchError((e){
          Fluttertoast.showToast(msg: e!.message);
        });
    }
  }
  postDetailsToFirestore() async{

    //Calling Firestore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    //Calling the User Model
    UserModel userModel = UserModel();

    //Writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.surName = surNameEditingController.text;

    //Inserting data into Firebase Firestore
    await firebaseFirestore
    .collection("user")
    .doc(user.uid)
    .set(userModel.toMap());

    Fluttertoast.showToast(msg: "Account created successfully :)");

    Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }
}
