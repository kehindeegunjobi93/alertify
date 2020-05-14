import 'package:alertify/utilities/colors.dart';
import 'package:alertify/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:alertify/screens/dashboard.dart';


class WelcomeScreen extends StatelessWidget {
  final String fullName;

  const WelcomeScreen({this.fullName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pColor,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Dear $fullName", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700)),
            SizedBox(height: 20.0),
            Text("Welcome to Alertify, you can start using the app by going to the Dashboard Page", 
                style: TextStyle(color: Colors.white.withOpacity(.7), height: 1.4, fontSize: 25, fontWeight: FontWeight.w500)),
            SizedBox(height: 30.0),
            CustomButton(func: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                DashboardScreen()
              ));
            }, text: 'Go to Dashboard')
          ],
        ),
      ),
    );
  }
}
