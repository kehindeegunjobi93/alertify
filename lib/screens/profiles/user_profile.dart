import 'package:alertify/utilities/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class UProfile extends StatefulWidget {

  final String fullName;
  final String phoneNumber;
  final String email;
  final String uid;

  const UProfile({Key key, this.fullName, this.phoneNumber, this.email, this.uid}) : super(key: key);

  @override
  _UProfileState createState() => _UProfileState();
}

class _UProfileState extends State<UProfile> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _phoneController;
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  GeoPoint coordinates;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController(text: widget.fullName);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        backgroundColor: pColor,
        title: Text('Update Personnel Profile'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: () {
            Firestore.instance.collection('users').document(widget.uid).updateData(
                {
                  'fullName': _nameController.text,
                  'phoneNumber': _phoneController.text,
                  'email': _emailController.text,
                }
            ).then((data){
              final snackBar = new SnackBar(
                content: Text('Your data has been updated successfully'),
                duration: Duration(seconds: 3),
                backgroundColor: pColor2,
              );
              scaffoldState.currentState.showSnackBar(snackBar);
            })
                .catchError((onError){
              print(onError);
              final snackBar = new SnackBar(
                content: Text('There was a problem while updating your data'),
                duration: Duration(seconds: 3),
                backgroundColor: Colors.red,
              );
              scaffoldState.currentState.showSnackBar(snackBar);
            });
          })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0,),
            Image.asset( 'assets/images/user.png', width: 64.0,),
            SizedBox(height: 20.0,),
            ListTile(
              leading: const Icon(Icons.person),
              title: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Name",
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            ListTile(
              leading: const Icon(Icons.phone),
              title: TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: "Phone",
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            ListTile(
              leading: const Icon(Icons.email),
              title: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                ),
              ),
            ),
            SizedBox(height: 20.0,),
          ],
        ),
      ),
    );
  }

}



