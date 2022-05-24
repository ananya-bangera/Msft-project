import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_advertising/model/emotion.dart';
import 'package:smart_advertising/model/firebase_file.dart';
import 'package:smart_advertising/pages/display_video.dart';
import 'package:video_player/video_player.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import '../main.dart';


class VideoPage extends StatefulWidget {
  final FirebaseFile file;
  const VideoPage({Key? key,required this.file}) : super(key: key);

  @override
  VideoPageState createState() => VideoPageState();
}

class VideoPageState extends State<VideoPage> {

  //For Displaying Video
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  //For saving the emotions list
  List<Emotion> emotionList =[];
   DatabaseReference reference = FirebaseDatabase.instance.ref(
     "Emotions/videos"
   );

  //For the analysis model
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';

  @override
  void initState(){

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
          // print(output);
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
              emotionList.add(Emotion(feelings: output, timestamp: _controller.value.position.inSeconds.toString()));
              Fluttertoast.showToast(msg: emotionList.length.toString());

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
            output+ " "+ _controller.value.position.inSeconds.toString()+",",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() async {
            if (_controller.value.isPlaying) {
              _controller.pause();
              // print(emotionList);

              for(int i =0;i<emotionList.length;i++){
              Fluttertoast.showToast(msg: emotionList.length.toString());
                await reference.child(emotionList[i].timestamp).set(emotionList[i].feelings.toString()).asStream();

              }

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
}

