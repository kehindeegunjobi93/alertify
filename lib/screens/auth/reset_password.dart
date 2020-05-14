import 'package:alertify/screens/dashboard.dart';
import 'package:alertify/utilities/colors.dart';
import 'package:alertify/widgets/custom_alert.dart';
import 'package:alertify/widgets/custom_button.dart';
import 'package:alertify/widgets/custom_textfield.dart';
import 'package:alertify/widgets/text_below.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  PersistentBottomSheetController _sheetController;
  bool loading = false;
  bool autoValidate = false;
  String errorMsg = '';

  String email= '';

  String emailValidator(String value){
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }


  void _resetPassword() async {
    if(_formKey.currentState.validate()){
      setState(() {
        loading = true;
      });
      try {
       await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
       setState((){
         errorMsg = "An email reset link has been sent over to your email.";
         loading = false;
       });
       showDialog(context: context,
           builder: (BuildContext context){
//             return AlertDialog(
//               content: Container(
//                 child: Text(errorMsg),
//               ),
//             );
             return CustomDialog(
               title: 'Success',
               description: errorMsg,
               buttonText: 'Okay',
               image: 'assets/images/correct.png',
               onPressed: (){
                 Navigator.of(context).pop();
               },
             );
           }
       );

      } catch (error) {
        switch(error.code){
          case "ERROR_USER_NOT_FOUND":
            {
              setState((){
                errorMsg = "There is no user with this email. Please try again.";
                loading = false;
              });
              showDialog(context: context,
                  builder: (BuildContext context){
//                    return AlertDialog(
//                      content: Container(
//                        child: Text(errorMsg),
//                      ),
//                    );
                    return CustomDialog(
                      title: 'Error',
                      description: errorMsg,
                      buttonText: 'Okay',
                      image: 'assets/images/wrong.png',
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    );
                  }
              );
            }
            break;
          default:
            {
              setState(() {
                errorMsg = "";
              });
            }
        }
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        sColor,
                        sColor2,
                        pColor2,
                        pColor,
                      ],
                      stops: [0.1, 0.4, 0.7, 0.9],
                    )
                ),
              ),
              Container(height: double.infinity,
                child: SingleChildScrollView(physics:
                AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 120.0),
                  child: Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Reset Password',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 30.0),
                        SizedBox(height: 30.0,),
                        CustomTextField(
                          text: 'Email',
                          icon: Icons.email,
                          hintText: 'Enter your email',
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          validator: emailValidator,
                        ),

                        Container(
                          child:
                          loading ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)
                              :
                          CustomButton(
                            func: _resetPassword,
                            text: 'SUBMIT',
                          ),
                        ),
                        SizedBox(height: 30.0,),
                        TextBelow(
                          func: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                LoginScreen()
                            ));
                          },
                          text1: 'Return to ',
                          text2: 'Login Page',

                        )

                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


}






