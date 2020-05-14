import 'package:alertify/screens/auth/login.dart';
import 'package:alertify/screens/broadcast/broadcast.dart';
import 'package:alertify/screens/map.dart';
import 'package:alertify/screens/profiles/personnel_profile.dart';
import 'package:alertify/screens/profiles/user_profile.dart';
import 'package:alertify/screens/search_page.dart';
import 'package:alertify/screens/the_map.dart';
import 'package:alertify/screens/use_search.dart';
import 'package:alertify/utilities/colors.dart';
import 'package:alertify/utilities/constants.dart';
import 'package:alertify/widgets/custom_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {

  final String user;

  const DashboardScreen({this.user});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var fullName;
  var userType;
  var email;
  var phoneNumber;
  var address;
  var uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  getUser() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  Firestore.instance.collection("users").document(firebaseUser.uid).get().then((value){
    setState(() {
      userType = value.data['userType'];
      fullName = value.data['fullName'];
      phoneNumber = value.data['phoneNumber'];
      email = value.data['email'];
      address = value.data['address'];
      uid = value.data['uid'];
    });
    if(address == '' && userType == 'Security Personnel'){
      showDialog(
          context: context,
          barrierDismissible: true,
        builder: (BuildContext context){
             return CustomDialog(
             title: 'Update Profile',
             description: 'Hi, update your address when you click on Personnel Profile so you can show up on the map',
             buttonText: 'Okay',
             image: 'assets/images/police.png',
             onPressed: (){
               Navigator.of(context).pop();
             },
          );
        }
      );
    }
  });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alertify', style: kLabelTextStyle,),
        centerTitle: true,
        //automaticallyImplyLeading: false,
        backgroundColor: pColor,
      ),

      body: ListView(
        children: <Widget>[
          SizedBox(height: 15.0,),
          Container(
            padding: EdgeInsets.all(35.0),
            width: MediaQuery.of(context).size.width - 30.0,
            height: MediaQuery.of(context).size.height - 50.0,
            child: GridView.count(
                crossAxisCount: 2,
                primary: false,
                crossAxisSpacing: 10.0,
              mainAxisSpacing: 15.0,
              childAspectRatio: 0.8,
              children: <Widget>[
                _buildCard(
                    'Use Map',
                    'assets/images/map.png',
                    context,
                        (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          AlertifyMap()
                      ));
                    }
                ),
                _buildCard(
                    'Use Search',
                    'assets/images/search.png',
                    context,
                      (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    SearchPage()
                  ));
                }
                ),
                userType == 'Civilian' ?
                _buildCard(
                    'Your Profile',
                    'assets/images/profile.png',
                    context,
                        (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              UProfile(
                                fullName: fullName,
                                phoneNumber: phoneNumber,
                                email: email,
                                uid: uid,
                              )
                          ));
                    }
                )
                    :
                _buildCard(
                    'Personnel Profile',
                    'assets/images/police.png',
                    context,
                        (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              PProfile(
                                fullName: fullName,
                                phoneNumber: phoneNumber,
                                email: email,
                                address: address,
                                uid: uid,
                              )
                          ));
                    }
                ),

                userType == 'Civilian' ?
                _buildCard(
                    'Broadcast Tools',
                    'assets/images/broadcast.png',
                    context,
                        (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                         BroadcastTools()
                      ));
                    }
                )
                    :
                 Container()
              ],
            ),
          )
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Your name: $fullName', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0), ),
              accountEmail: Text('Your email: $email'),
              decoration: BoxDecoration(color: pColor),
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text("Terms and Conditions"),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Support"),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: (){
                launch("mailto:alertify@gmail.com?subject=SOS%20From%20Alertify&body=We%20need%20your%20help");
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text("Log Out"),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('email');
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                   LoginScreen()
                ));
          },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String pageName, String imgPath, context, Function func){
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 15.0, left: 5.0, right: 5.0),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: func,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3.0,
                  blurRadius: 5.0
                )
              ],
              color: Colors.white
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                   Hero(tag: imgPath,
                       child: Container(
                         height: 60.0,
                         decoration: BoxDecoration(
                           image: DecorationImage(
                               image: AssetImage(
                                   imgPath,
                               ),
                               fit: BoxFit.contain
                           )
                         ),
                       )),
                Text(pageName,
                   textAlign: TextAlign.center,
                   style: TextStyle(
                     color: pColor,
                     fontSize: 20.0,
                     fontWeight: FontWeight.bold
                   ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
