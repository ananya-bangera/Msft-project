import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_advertising/model/user_model.dart';
import 'package:smart_advertising/pages/authenticationService.dart';
import 'package:provider/provider.dart';
import 'package:smart_advertising/pages/home.dart';

class SignInPage extends StatelessWidget {
  //form key
  final _formKey = GlobalKey<FormState>();

  //Editing Controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //Firebase
  final _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    //Email Field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
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
        onSaved: (value) {
          emailController.text = value!;
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
        controller: passwordController,
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
        onSaved: (value) {
          passwordController.text = value!;
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

    //Login Button
    final logInButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        onPressed: () => signIn(emailController.text, passwordController.text, context),
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
        backgroundColor: Theme
            .of(context)
            .appBarTheme
            .backgroundColor,
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
                        child: Image.asset('assets/welcome.png', width: 350,),
                      ),
                      SizedBox(height: 15,),
                      emailField,
                      SizedBox(height: 45,),
                      passwordField,
                      SizedBox(height: 45,),
                      logInButton,
                      SizedBox(height: 45,),
                    ],
                  ),
                ),
              )
          ),
        ),
      ),
    );
  }

//Login Function
void signIn(String email, String password, BuildContext context)async {
  if (_formKey.currentState!.validate()) {
    await _auth.signInWithEmailAndPassword(email: email, password: password)
        .then((uid) => {
    Fluttertoast.showToast(msg: "Login Successful"),
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()))
    }).catchError((e){
      Fluttertoast.showToast(msg: e!.message);

    });
  }
}

}
