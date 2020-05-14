import 'package:alertify/screens/auth/register.dart';
import 'package:alertify/screens/auth/reset_password.dart';
import 'package:alertify/screens/dashboard.dart';
import 'package:alertify/utilities/colors.dart';
import 'package:alertify/utilities/constants.dart';
import 'package:alertify/widgets/custom_alert.dart';
import 'package:alertify/widgets/custom_button.dart';
import 'package:alertify/widgets/custom_textfield.dart';
import 'package:alertify/widgets/text_below.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool loading = false;
  bool autoValidate = false;
  String errorMsg = '';

  String email= '';
  String password = '';

  bool _rememberMe = false;

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

  String passValidator(String val){
    if(val.length < 1)
      return 'Password field cannot be empty';
    else
      return null;
  }


  void _loginUser() async {
    if(_formKey.currentState.validate()){
      setState(() {
        loading = true;
      });
      if(_rememberMe == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);
      }
      try {
        FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)).user;

        Navigator.push(context, MaterialPageRoute(builder: (context) =>
          DashboardScreen()
        ));

      } catch (error) {
        switch(error.code){
          case "ERROR_USER_NOT_FOUND":
            {
              setState((){
                errorMsg = "There is no user with such entries. Please try again.";
                loading = false;
              });
              showDialog(context: context,
                builder: (BuildContext context){
//                return AlertDialog(
//                  content: Container(
//                    child: Text(errorMsg),
//                  ),
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
          case "ERROR_WRONG_PASSWORD":
            {
              setState(() {
                errorMsg = "Password doesn\'t match your email";
                loading = false;
              });
              showDialog(context: context,
                builder: (BuildContext context){
//                return AlertDialog(
//                  content: Container(
//                    child: Text(errorMsg),
//                  ),
//                );
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
                      Text('Sign In',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                           fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 30.0),
                  CustomTextField(
                    text: 'Email',
                    icon: Icons.email,
                    hintText: 'Enter your email',
                    inputType: TextInputType.emailAddress,
                    onChanged: (val) {
                         setState(() {
                           email = val;
                         });
                    },
                    validator: emailValidator,
                  ),
                      SizedBox(height: 30.0,),
                  CustomTextField(
                    text: 'Password',
                    icon: Icons.lock,
                    hintText: 'Enter your password',
                    obscure: true,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                    validator: passValidator,
                  ),
                      buildForgotPassword(),
                      Container(
                        height: 20.0,
                        child: Row(
                        children: <Widget>[
                          Theme(data: ThemeData(unselectedWidgetColor: Colors.white),
                              child: Checkbox(value: _rememberMe,
                                  checkColor: Colors.green,
                                  activeColor: Colors.white,
                                  onChanged: (value){
                                        setState(() {
                                          _rememberMe = value;
                                        });
                                  })),
                          Text("Remember me", style: kLabelTextStyle,)
                        ],
                      ),),
                  Container(
                    child:
                    loading ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)
                    :
                    CustomButton(
                      func: _loginUser,
                      text: 'LOGIN',
                    ),
                  ),
                      SizedBox(height: 30.0,),
                      TextBelow(
                        func: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            RegisterScreen()
                          ));
                        },
                        text1: 'Don\'t have an account? ',
                        text2: 'Sign Up',

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

  Container buildForgotPassword() {
    return Container(
                alignment: Alignment.centerRight,
                child: FlatButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    ResetPasswordScreen()
                  ));
                },
                    padding: EdgeInsets.only(right: 0.0),
                    child: Text(
                  'Forgot Password?',
                style: kLabelTextStyle,)),
              );
  }

}






