import 'package:alertify/screens/auth/login.dart';
import 'package:alertify/screens/auth/welcome.dart';
import 'package:alertify/utilities/colors.dart';
import 'package:alertify/utilities/constants.dart';
import 'package:alertify/widgets/custom_alert.dart';
import 'package:alertify/widgets/custom_button.dart';
import 'package:alertify/widgets/custom_textfield.dart';
import 'package:alertify/widgets/text_below.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  PersistentBottomSheetController _sheetController;
  final codeController = TextEditingController();
  bool _loading = false;

  List<String> userTypes = [
    "Civilian",
    "Security Personnel",
  ];


  String fullName = '';
  String phoneNumber;
  String email = '';
  String password = '';
  String errorMsg = '';
  String userType = "";


  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 6) {
      return 'Password must be longer than 6 characters';
    } else {
      return null;
    }
  }

  String validatePhone(String value) {
    if (value.length != 14) {
      return 'Mobile number is empty or not correct';
    } else if(!value.contains('+234')) {
      return 'Please add the country code';
    } else {
      return null;
    }
  }

  _registerUser() async {
    final FormState form = _formKey.currentState;
    if (_formKey.currentState.validate()) {
      form.save();
      setState(() {
        _loading = true;
      });
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: email, password: password))
            .user;

        UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
        userUpdateInfo.displayName = fullName;
        user.updateProfile(userUpdateInfo).then((onValue) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WelcomeScreen(
                        fullName: fullName,
                      )));
        });
        Firestore.instance.collection('users').document(user.uid).setData({
          'email': email,
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'uid': user.uid,
          'userType': userType,
          'address': '',
          'searchKey': fullName.substring(0,1)
        }).then((onValue) {
          _sheetController.setState(() {
            _loading = false;
          });
        });
      } catch (error) {
        switch (error.code) {
          case "ERROR_EMAIL_ALREADY_IN_USE":
            {
              setState(() {
                errorMsg = "This email is already in use.";
                _loading = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
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
                  });
            }
            break;
          case "ERROR_WEAK_PASSWORD":
            {
              setState(() {
                errorMsg = "This password must be 6 chracters long or more";
                _loading = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
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
                  });
            }
            break;
          default:
            {
              setState(() {
                errorMsg = "";
                _loading = true;
              });
            }
        }
      }
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
                    colors: [sColor, sColor2, pColor2, pColor],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  )),
                ),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 85.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          CustomTextField(
                            text: 'Full Name',
                            icon: Icons.person,
                            hintText: 'Firstname Lastname',
                            onChanged: (val) {
                              setState(() {
                                fullName = val;
                              });
                            },
                            validator: (val) =>
                                val.isEmpty ? 'Enter your fullname' : null,
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          CustomTextField(
                            text: 'Phone',
                            icon: Icons.phone_android,
                            hintText: '+23481234567890',
                            inputType: TextInputType.phone,
                            onChanged: (String val) {
                              setState(() {
                                phoneNumber = val;
                              });
                            },
                            validator: validatePhone,
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          CustomTextField(
                            text: 'Email',
                            icon: Icons.mail_outline,
                            hintText: 'email@email.com',
                            inputType: TextInputType.emailAddress,
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                            validator: (val) =>
                                val.isEmpty ? 'Enter an email' : null,
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
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
                            validator: pwdValidator,
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('User Type', style: kLabelTextStyle,),
                            SizedBox(height: 10.0,),
                            Container(
                              alignment: Alignment.centerLeft,
                              decoration: kBoxDecorationStyle,
                              height: 60.0,
                              child: DropdownButtonFormField<String>(
                                icon: Icon(                // Add this
                                  Icons.arrow_drop_down,  // Add this
                                  color: Colors.white,   // Add this
                                ),                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 7.5, right: 10.0),
                                    prefixIcon: Icon(
                                      Icons.people,
                                      color: Colors.white,
                                    ),
                                    hintText: 'Please enter your user type',
                                    hintStyle: kHintTextStyle
                                ),
                                value: userType == '' ? null : userType,
                                onChanged: (String newValue) {
                                  setState(() {
                                    userType = newValue;
                                  });
                                },
                                validator: (value) => value.isEmpty ? 'Please enter a valid user type' : null,
                                items: userTypes.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                          Container(
                            child: _loading
                                ? CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                  )
                                : CustomButton(
                                    func: _registerUser,
                                    text: 'REGISTER',
                                  ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            errorMsg,
                            style: kLabelTextStyle,
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          TextBelow(
                              func: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              },
                              text1: 'Already have an account? ',
                              text2: 'Login')
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
