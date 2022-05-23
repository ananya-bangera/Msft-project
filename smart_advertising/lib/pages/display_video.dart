import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_advertising/api/firebase_api.dart';
import 'package:smart_advertising/pages/video_page.dart';

import '../model/firebase_file.dart';

class DisplayVideo extends StatefulWidget {
  final String? category_name;
  const DisplayVideo(this.category_name);
  @override
  State<DisplayVideo> createState() => _DisplayVideoState();
}

class _DisplayVideoState extends State<DisplayVideo> {
  late Future<List<FirebaseFile>> futureFiles;
  @override
  void initState(){
    super.initState();
    futureFiles=FirebaseApi.listAll('files/${widget.category_name}/');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Adv"),
          backgroundColor:Theme.of(context).appBarTheme.backgroundColor ,

        ),
        body: FutureBuilder<List<FirebaseFile>>(
          future: futureFiles,
          builder: (context, snapshot){
            switch( snapshot.connectionState){
              case
                 ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
              default:
                if(snapshot.hasError){
                  return Center(child: Text('Some error occurred'),);

                }
                else{

                  final files = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildHeader(files.length),
                      const SizedBox(height: 12,),
                      Expanded(
                          child: ListView.builder(
                              itemCount: files.length,
                              itemBuilder: (context, index){
                                final file = files[index];
                                return buildFile(context, file);
                              }
                          )
                      )


                    ],
                  );

                }
            }
          },
        )
    );
  }

 Widget buildHeader(int length) {
    return ListTile(
      tileColor: Colors.grey,
      leading: Container(
        width: 52,
        height: 52,
        child: Icon(
          Icons.file_copy_rounded,
          color: Colors.white,
        )
      ),
      title: Text(
        '$length Files',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize:20,
          color: Colors.white
        ),
      ),
    );

  }

  Widget buildFile(BuildContext context, FirebaseFile file) {
    return ListTile(
      leading: ClipOval(
        child: Image.network(
          file.url,
          width: 52,
          height: 52,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        file.name,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:20,
            color: Colors.white

        ),


      ),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VideoPage(file: file),
        ));
      },
    );
  }
}