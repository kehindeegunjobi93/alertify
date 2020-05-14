import 'dart:async';

import 'package:alertify/animations/fadeanimation.dart';
import 'package:alertify/screens/auth/login.dart';
import 'package:alertify/screens/dashboard.dart';
import 'package:alertify/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin{

  AnimationController _scaleController;
  AnimationController _scale2Controller;
  AnimationController _widthController;
  AnimationController _positionController;

  Animation<double> _scaleAnimation;
  Animation<double> _scale2Animation;
  Animation<double> _widthAnimation;
  Animation<double> _positionAnimation;

  bool hideIcon = false;

  loggedIn() async {

  }

  @override
   initState() {
    super.initState();
    Timer(
    Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.getString('email');
      if (email == null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen()
        ));

      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (BuildContext context) =>
            DashboardScreen()
        ));
      }
    }
    );

    _scaleController = AnimationController(vsync: this,
    duration: Duration(milliseconds: 300)
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8
    ).animate(_scaleController)..addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _widthController.forward();
      }
    });

    _widthController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600)
    );

    _widthAnimation = Tween<double>(
      begin: 80.0,
      end: 300.0
    ).animate(_widthController)..addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _positionController.forward();
      }
    });

    _positionController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000)
    );

    _positionAnimation = Tween<double>(
        begin: 0.0,
        end: 215.0
    ).animate(_positionController)..addStatusListener((status){
      if(status == AnimationStatus.completed){
        setState(() {
          hideIcon = true;
        });
         _scale2Controller.forward();
      }
    });

    _scale2Controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000)
    );

    _scale2Animation = Tween<double>(
        begin: 1.0,
        end: 32.0
    ).animate(_scale2Controller)..addStatusListener((status){
      if(status == AnimationStatus.completed){
        Navigator.push(context,
            PageTransition(type: PageTransitionType.fade,
                child: LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: pColor,
      body: Container(
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: -150,
                left: 0,
                child: FadeAnimation(
                  1.6, Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      width: width,
                      height: 400,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/one.png')
                          )
                      ),
                    ),
                  ),
                )),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(1, Text("Alertify",
                  style: TextStyle(color: Colors.white, fontSize: 40),
                  )),
                  SizedBox(height: 15,),
                  FadeAnimation(1.3, Text("Send alerts in time of emergency to relevant agencies",
                  style: TextStyle(color: Colors.white.withOpacity(.7), height: 1.4, fontSize: 15),
                  )),
                  SizedBox(height: 180,),
                  SizedBox(height: 60,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }





}

