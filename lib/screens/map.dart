import 'dart:async';
import 'dart:ui';

import 'package:alertify/utilities/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AlertifyMap extends StatefulWidget {
  @override
  _AlertifyMapState createState() => _AlertifyMapState();
}

class _AlertifyMapState extends State<AlertifyMap> {

  Position currentLocation;
  bool userToggle = false;
  var users = [];

  GoogleMapController mapController;
  String searchAddr;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  var filterDist;

  @override
  void initState() {
    getCurrentLocation();
    getMarkers();
    super.initState();
  }

  void getCurrentLocation() async {
    await Geolocator().getCurrentPosition().then((currLoc){
      setState(() {
        currentLocation = currLoc;
      });
    });
  }

  Set<Marker> createMarker(){
    return <Marker>[
      Marker(
        markerId: MarkerId("Home"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "Home"),
      )
    ].toSet();
  }

 getMarkers(){
    users=[];
    Firestore.instance.collection("users")
        .where('userType', isEqualTo: 'Security Personnel')
        .getDocuments().then((docs){
      if(docs.documents.isNotEmpty){
        setState(() {
          userToggle = true;
        });
        for(int i =0; i < docs.documents.length; ++i){
          users.add(docs.documents[i].data);
          initMarker(docs.documents[i].data, docs.documents[i].documentID);
        }
      }
    });
 }

  void initMarker(user, userId){
    var markerIdVal = userId;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(user['coordinates'].latitude, user['coordinates'].longitude),
      //infoWindow: InfoWindow(title: user['fullName'], snippet: user['address']),
      icon: BitmapDescriptor.defaultMarkerWithHue(2.0),
      onTap: (){
        showModalBottomSheet(context: context,
            builder: (context) => Container(
                height: 250,

                child: Column(

                  children: <Widget>[

                    Expanded(

                      child: Container(
                          color: pColor,
                          width: double.infinity,

                          child: Padding(
                            padding: EdgeInsets.all(18.0),
                            child: new Column(
                                children: <Widget>[
                                  Text(user['fullName'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22.0,
                                          color: Colors.white
                                      )),
                                  Text(user['address'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0,
                                          color: Colors.white
                                      )),
                                ]),
                          )
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.chat_bubble, color: pColor,),
                      title: Text('Chat Now',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: pColor
                          )),
                      onTap: (){
                        launchWhatsApp(user);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.call, color: pColor),
                      title: Text('Call Now',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: pColor
                          )),
                      onTap: (){
                        launch("tel:${user['phoneNumber']}");
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.email, color: pColor),
                      title: Text('Send Email',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: pColor
                          )),
                      onTap: (){
                        launch("mailto:${user['email']}?subject=SOS%20From%20Alertify&body=We%20need%20your%20help");
                      },
                    )
                  ],
                )
            )

        );
      }
    );
    setState(() {
      markers[markerId] = marker;
    });
 }

 Widget UserCard(user){
    return Padding(
      padding: EdgeInsets.only(left: 2.0, top: 10.0),
      child: InkWell(
        onTap: (){
          zoomInMarker(user);
        },
        child: Container(
          height: 100,
          width: 125.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white
          ),
          child: Center(
            child: Text(user['fullName']),
          ),
        ),
      ),
    );
 }

 zoomInMarker(user){
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(user['coordinates'].latitude, user['coordinates'].longitude ),
          zoom: 14.0,
          bearing: 90.0,
          tilt: 45.0
      ),
    ));
 }

 filterMarkers(dist){
    for(int i=0; i<users.length; i++){
      Geolocator().distanceBetween(currentLocation.latitude, 
          currentLocation.longitude, users[i]['coordinates'].latitude, 
          users[i]['coordinates'].longitude).then((calDist){
            if(calDist / 1000 < double.parse(dist)){
              placeFilteredMarker(users[i], calDist / 1000);
            }
      });
    }
 }

 placeFilteredMarker(user, dist){
//    mapController.clearMarkers().then((val){
//      mapController.addMarker(MarkerOptions(
//          draggable: false,
//          position: LatLng(user['coordinates'].latitude, user['coordinates'].latitude)
//      ));
//    });
 }

  void launchWhatsApp(user) async {
    String phoneNumber = user['phoneNumber'];
    String message = 'Hello from Alertify app';
    var whatsappUrl = "whatsapp://send?phone=$phoneNumber&text=$message";
    if(await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Alertify Map',textAlign: TextAlign.center,style: TextStyle(color: CupertinoColors.white),),
//          actions: <Widget>[
//            IconButton(
//                icon: Icon(Icons.filter_list),
//                onPressed: getDist
//                  )
//          ],
        ),
        body: Stack(
          children: <Widget>[
            currentLocation == null
                ?
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(pColor),
                  ),
                )
            :
            GoogleMap(
              markers: Set<Marker>.of(markers.values),
              onMapCreated: onMapCreated,
              initialCameraPosition: CameraPosition(
                  bearing: 180.0,
                  target: LatLng(currentLocation.latitude, currentLocation.longitude),
                  zoom: 15.0,
                  tilt: 30.0,
              ),
            ),
            Positioned(
              top: 50.0,
              right: 15.0,
              left: 15.0,
              child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    contentPadding: EdgeInsets.only(
                      left: 15.0,
                      top: 15.0
                    ),
                    fillColor: Color(0xFFEEEEEE),
                    filled: true,
                    suffixIcon: IconButton(icon: Icon(Icons.search),
                        onPressed: searchAndNavigate,
                        iconSize: 30.0,
                    )
                  ),
                  onChanged: (val){
                    setState(() {
                      searchAddr = val;
                    });
                  },
                ),
              ),
            ),
            
            Positioned(
              top: MediaQuery.of(context).size.height - 250.0,
              left: 10.0,
              child: Container(
                height: 125.0,
                width: MediaQuery.of(context).size.width,
                child: userToggle ? ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(8.0),
                  children: users.map((element){
                    return UserCard(element);
                  }).toList(),
                ) : Container(height: 1.0, width: 1.0),
              ),
            )
          ]
        )
    );
  }

  searchAndNavigate(){
    Geolocator().placemarkFromAddress(searchAddr).then((result){
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
       target: LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 10.0
        )
      ));
    });
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Future<bool> getDist(){
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context){
          return AlertDialog(
            title: Text('Enter Distance'),
            contentPadding: EdgeInsets.all(10.0),
            content: TextField(
              decoration: InputDecoration(hintText: 'Enter Distance'),
              onChanged: (val){
                   setState(() {
                     filterDist = val;
                   });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                color: Colors.transparent,
                textColor: Colors.blue,
                onPressed: (){
                  filterMarkers(filterDist);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }


}