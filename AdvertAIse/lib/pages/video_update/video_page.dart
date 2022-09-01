import 'package:advertaise/model/video_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:advertaise/model/emotion_list.dart';
import 'package:advertaise/model/firebase_file.dart';
import 'package:video_player/video_player.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import '../../main.dart';

class VideoPage extends StatefulWidget {
  final FirebaseFile file;
  final String fileName;
  const VideoPage({Key? key, required this.file, required this.fileName})
      : super(key: key);

  @override
  VideoPageState createState() => VideoPageState();
}

class VideoPageState extends State<VideoPage> {
  //Firebase
  final _auth = FirebaseAuth.instance;

  //For Displaying Video
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  //For saving the emotions list
  DatabaseReference reference =
      FirebaseDatabase.instance.ref("Emotions/videos").push();

  Map<String, String> emotionList = {};

  //For the analysis model
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';

  @override
  void initState() {
    _controller = VideoPlayerController.network('${widget.file.url}');
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    super.initState();
    loadCamera();
    loadmodel();
  }

  loadCamera() {
    cameraController = CameraController(cameras![0], ResolutionPreset.high);
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController!.startImageStream((imageStream) {
            cameraImage = imageStream;
            runModel();
          });
        });
      }
    });
  }

  runModel() async {
    if (cameraImage != null) {
      var predictions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 2,
          threshold: 0.1,
          asynch: true);
      predictions!.forEach((element) {
        setState(() {
          output = element['label'];
        });
      });
    }
  }

  loadmodel() async {
    await Tflite.loadModel(
        model: "assets/model.tflite", labels: "assets/labels.txt");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adv"),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              emotionList[_controller.value.position.inSeconds.toString()] =
                  output;
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Text(
            widget.fileName +
                " " +
                output +
                " " +
                _controller.value.position.inSeconds.toString() +
                "",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() async {
            if (_controller.value.isPlaying) {
              _controller.pause();

              createEmotion(emotionList);
              Navigator.of(context).pop();
            } else {
              _controller.play();
            }
          });
        },
        child:
            Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }

  createEmotion(Map<String, String> emotionList) async {
    double sizeOfVideo = _controller.value.size.width;
    double watchedVideo = emotionList.length * 1.0;
    User? user = _auth.currentUser;
    String? userName = user?.displayName;
    VideoDataModel videoDataModel = VideoDataModel(
        score: (watchedVideo * 1.0) / sizeOfVideo,
        lastUpdated: DateTime.now(),
        userName: userName);
    EmotionListModel emotionListModel = EmotionListModel();
    emotionListModel.eml = emotionList;

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection("Emotions")
        .doc(widget.fileName.toString())
        .collection("collection")
        .doc(user?.email)
        .set(emotionListModel.toMap());
    await firebaseFirestore
        .collection("Watched")
        .doc(user?.email)
        .collection(widget.fileName.toString())
        .doc("details")
        .set(videoDataModel.toMap());
  }
}
