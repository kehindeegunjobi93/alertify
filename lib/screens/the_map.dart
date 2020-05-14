//import 'package:alertify/utilities/colors.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_map/flutter_map.dart';
//import 'package:latlong/latlong.dart';
//
//class TheMap extends StatefulWidget {
//  @override
//  _TheMapState createState() => _TheMapState();
//}
//
//class _TheMapState extends State<TheMap> {
//  List<Marker> allMarkers = [];
//
//  setMarkers(){
//    return allMarkers;
//  }
//
//  Widget loadMap(){
//    return StreamBuilder(
//        stream: Firestore.instance.collection("users").where('userType', isEqualTo: 'Security Personnel').snapshots(),
//        builder: (context, snapshot){
//            if(!snapshot.hasData) return CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(pColor));
//            print(snapshot.data.documents.length);
//
//            for(int i=0; i<snapshot.data.documents.length; i++){
//              print(snapshot.data.documents[i]['coordinates'].latitude);
//              allMarkers.add(Marker (
//                width: 45.0,
//                height: 45.0,
//                point: LatLng(snapshot.data.documents[i]['coordinates'].latitude, snapshot.data.documents[i]['coordinates'].longitude),
//                builder: (context) => Container(
//                  child: IconButton(
//                      icon: Icon(Icons.location_on),
//                      color: Colors.blue,
//                      iconSize: 45.0,
//                      onPressed: (){
//                        print(snapshot.data.documents[i]['fullName']);
//                      }),
//                )
//              ));
//            }
//           return FlutterMap(
//              options: MapOptions(
//                center: LatLng(7.412068, 3.9058659),
//                minZoom: 10.0,
//              ),
//              layers: [
//                TileLayerOptions(
//                    urlTemplate: "https://api.mapbox.com/styles/v1/kehindeegunjobi/ck9e1tdtf04251iqs3t2cb8tj/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia2VoaW5kZWVndW5qb2JpIiwiYSI6ImNrMW00b2xteDBicnMzaHAzM2I1aHdwNHIifQ.pv1SnpHPDeNBOHK3wdgJ1g",
//                    additionalOptions: {
//                      'accessToken': 'pk.eyJ1Ijoia2VoaW5kZWVndW5qb2JpIiwiYSI6ImNrOWN6cWJubTAzcGUzZnBqOG1menlqYjYifQ.ICFu5AmoCyCpWP2drvKTaA',
//                      'id': 'mapbox.mapbox-streets-v8'
//                    }
//                ),
//                MarkerLayerOptions(markers: allMarkers)
//              ],
//            );
//        },
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Map'),
//        centerTitle: true,
//        backgroundColor: pColor,
//      ),
//      body: loadMap()
//    );
//  }
//}
