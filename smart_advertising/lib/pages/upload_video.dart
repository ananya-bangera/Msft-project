import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:smart_advertising/pages/home.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api/firebase_api.dart';

class UploadVideo extends StatefulWidget {
  final String? category_name;
  const UploadVideo(this.category_name);
  @override
  _UploadVideoState createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {

  //Firebase
  CollectionReference filesList = FirebaseFirestore.instance.collection("Uploads");
  final _auth = FirebaseAuth.instance;
  UploadTask? task;
  File? file;

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.category_name}"),
        backgroundColor:Theme.of(context).appBarTheme.backgroundColor ,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape:  new CircleBorder(),
                  padding: EdgeInsets.all(100),
                  primary: Colors.orange
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    ButtonText(fileName),

                    // Icon(Icons.attach_file)
                 ],
                ),
                onPressed: (){
                  if(fileName=='No File Selected') {
                    selectFile();
                  }
                  else {
                    uploadFile(widget.category_name);
                  }
                },
              ),
              SizedBox(height: 200),
              Text(
                fileName,
                style: GoogleFonts.montserrat(
                    fontSize: 16, fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(height: 48),

              SizedBox(height: 20),
              task != null ? buildUploadStatus(task!) : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile(String? category_name ) async {
    if (file == null) return;

    final fileName = basename(file!.path);
    // final destination = 'files/${fileName}';
    final destination = 'files/${category_name}/${fileName}';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    insertUploads();
    print('Download-Link: $urlDownload');
    Fluttertoast.showToast(msg: "Successfully uploaded the Advertisement");
    Navigator.of(this.context).pop();

  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);
        return  Center(
          child: SpinKitDoubleBounce(
            size: 140,
            duration: const Duration(seconds : 2),
            itemBuilder: (context, index){
              final colors = [Colors.white, Colors.pink, Colors.yellow];
              final color = colors[index% colors.length];
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                ),
              );
            },
          ),
        );

      }
      else{
        return Container();
      }
    },
  );
  insertUploads() async {

    User? user = _auth.currentUser;
    FirebaseFirestore firebaseFirestore= FirebaseFirestore.instance;
    // DocumentSnapshot snapshot = await filesList.doc(_auth.currentUser?.email.toString()).collection("categories").doc(widget.category_name.toString()).get();
    // var data = snapshot.data() as Map;
    // var categories = data[widget.category_name.toString()] as List<dynamic>;
    await firebaseFirestore.collection("Uploads").doc(user?.email).collection("categories").doc(widget.category_name.toString()).set({basename(file!.path):""},SetOptions(merge: true));
    

  }
}

Widget ButtonText(String fileName) {
  if(fileName=='No File Selected') {
    return Text(
      'Select Video',
      style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
  return Text(
    'Upload Video',
    style: GoogleFonts.montserrat(
        fontSize: 15,
        fontWeight: FontWeight.bold
    ),

  );
}