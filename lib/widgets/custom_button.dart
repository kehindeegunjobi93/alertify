import 'package:alertify/utilities/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final Function func;
  final String text;

  const CustomButton({@required this.func, @required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: func,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.white,
        child: Text(text, style: TextStyle(
          color: blueText,
          letterSpacing: 1.5,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),),
      ),
    );
  }
}