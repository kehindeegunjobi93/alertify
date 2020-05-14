import 'package:alertify/utilities/colors.dart';
import 'package:alertify/widgets/custom_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  Future getPersonnel() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore.collection("users").where("userType", isEqualTo: "Security Personnel").getDocuments();

    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Container(
        child: FutureBuilder(
          future: getPersonnel(),
            builder: (_, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: Text("No Data Available Yet ..."),
            );
          } else {
             return ListView.builder(
                 itemCount: snapshot.data.length,
                 itemBuilder: (_, index){
                return GestureDetector(
                onTap: () {
                  showModalBottomSheet(context: context,
                      builder: (context) =>
                          Container(
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
                                                Text(snapshot.data[index].data["fullName"],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        fontSize: 22.0,
                                                        color: Colors.white
                                                    )),
                                                Text(snapshot.data[index].data["address"],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        fontSize: 12.0,
                                                        color: Colors.white
                                                    )),
                                              ]),
                                        )
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.chat_bubble, color: pColor,),
                                    title: Text('Chat Now',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: pColor
                                        )),
                                    onTap: () {
                                      launchWhatsApp(snapshot.data[index].data["phoneNumber"]);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.call, color: pColor),
                                    title: Text('Call Now',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: pColor
                                        )),
                                    onTap: () {
                                      launch("tel:${snapshot.data[index].data["phoneNumber"]}");
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.email, color: pColor),
                                    title: Text('Send Email',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: pColor
                                        )),
                                    onTap: () {
                                      launch(
                                          "mailto:${snapshot.data[index].data["email"]}?subject=SOS%20From%20Alertify&body=We%20need%20your%20help");
                                    },
                                  )
                                ],
                              )
                          )

                  );
                },
                  child: Card(
                    elevation: 8.0,
                    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    child: ListTile(
                      title: Text(snapshot.data[index].data["fullName"], style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ),
                );
             });
          }
        }),
      )
    );
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
}
