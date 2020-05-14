import 'dart:io';
import 'package:alertify/utilities/colors.dart';
import 'package:alertify/widgets/custom_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class RecordLive extends StatefulWidget {
  @override
  _RecordLiveState createState() => _RecordLiveState();
}

class _RecordLiveState extends State<RecordLive> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  showSnackbar(){
    final snackbar = SnackBar(
        content: Text('Your video has been successfully uploaded'),
      duration: Duration(seconds: 3),

    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

 File cameraVideo;
 VideoPlayerController cameraVideoPlayerController;

 String userEmail;



 Future recordVideo() async {
   File video = await ImagePicker.pickVideo(source: ImageSource.camera);
  setState(() {
    cameraVideo = video;
  });
   cameraVideoPlayerController = VideoPlayerController.file(cameraVideo)..initialize().then((_) {
     setState(() { });
     cameraVideoPlayerController.play();
   });
 }

 getUserEmail() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   setState(() {
      userEmail = prefs.getString('email');

   });
 }

 @override
  void initState() {
    // TODO: implement initState
   getUserEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: pColor,
        title: Text('Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
           child: Container(
              child: Column(
                children: <Widget>[
                  cameraVideo != null ?
                    cameraVideoPlayerController.value.initialized
                    ? AspectRatio(
                      aspectRatio: 3 / 2 ,
                      child: VideoPlayer(cameraVideoPlayerController),
                    )
                : Container()
                    :
                    Text("Click the blue button below to start recording", style: TextStyle(fontSize: 18.0),),
                CustomButton(
                    func: (){
                    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('$userEmail on ${DateTime.now()}');
                    final StorageUploadTask = firebaseStorageRef.putFile(cameraVideo);
                      final snackbar = SnackBar(
                        content: Text('Your video has been successfully uploaded'),
                        duration: Duration(seconds: 3),

                      );
                      scaffoldKey.currentState.showSnackBar(snackbar);

                     },
                    text: 'UPLOAD TO ALERTIFY')
          ]
              ),
            ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Start Recording',
       onPressed: recordVideo,
       child: Icon(Icons.videocam),
      ),
    );
  }

}


