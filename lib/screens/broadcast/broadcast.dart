import 'package:alertify/screens/broadcast/record.dart';
import 'package:alertify/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:geolocator/geolocator.dart';

class BroadcastTools extends StatefulWidget {

  @override
  _BroadcastToolsState createState() => _BroadcastToolsState();
}

class _BroadcastToolsState extends State<BroadcastTools> {
  double lat;
  double long;
  var currentAddress;

  @override
  void initState() {
    // TODO: implement initState
    getGeolocation();
    super.initState();
  }

  getGeolocation() async {
    var currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    var currentLoc = await getAddress(currentLocation);


    setState(() {
      currentAddress = currentLoc;
    });
    print(currentAddress);
  }

  Future<String> getAddress(Position pos) async {
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      return pos.thoroughfare + ', ' + pos.locality;
    }
    return pos.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pColor,
        title: Text('Broadcast Tools'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            broadcastCards(
            'Record Live',
                'Record an occurence and send it to our server',
                'assets/images/video.png',
                pColor,
                Colors.white,
                pColor,
                (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                     RecordLive()
                  ));
                }
            ),

            broadcastCards(
                'Facebook',
                'Post to facebook',
                'assets/images/facebook.png',
                Color(0xFF4267b2),
                Colors.white,
                pColor,
                    (){
                      FlutterShareMe().shareToFacebook(
                           msg: 'Hello, I need your help, I\'m at $currentAddress' );
                }
            ),

            broadcastCards(
                'Twitter',
                'Post to twitter',
                'assets/images/twitter.png',
                Color(0xFF1A91DA),
                Colors.white,
                pColor,
                    (){
                      FlutterShareMe().shareToTwitter(
                           msg: 'Hello twitter, I need your help, I\'m at $currentAddress');
                }
            ),

            broadcastCards(
                'Whatsapp',
                'Post to Whatsapp',
                'assets/images/whatsapp.png',
                Color(0xFF248F85),
                Colors.white,
                pColor,
                    (){
                      FlutterShareMe().shareToWhatsApp(base64Image: '', msg: 'Hello I need your help I\'m at $currentAddress');
                }
            ),
          ],
        ),
      )
    );
  }

  Widget broadcastCards(String title, String subtitle, String icon, Color bgColor, Color fontColor, Color iconColor, Function func){
    return GestureDetector(
      onTap: func,
      child: Padding(
        padding: EdgeInsets.only(top: 20.0, left: 15.0, right: 17.0, bottom: 10.0),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          elevation: 4.0,
          child: Container(
            height: 125.0,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: bgColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Image(image: AssetImage(icon)),
                  ),
                  Container(
                    width: 230,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(title, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500, color: fontColor),),
                          ),
                          Text(subtitle, style: TextStyle(fontSize: 17, color: fontColor)),
                        ]
                    ),
                  ),
                ],

              ),
            ),
          ),
        ),
      ),
    );
  }
}
