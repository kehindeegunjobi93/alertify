import 'package:alertify/utilities/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final IconData icon;
  final String hintText;
  final inputType;
  final bool obscure;
  final Function onChanged;
  final Function validator;

  CustomTextField({
    @required this.text,
    @required this.icon,
    @required this.hintText,
    @required this.onChanged,
    this.inputType,
    this.obscure = false, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(text, style: kLabelTextStyle,),
        SizedBox(height: 10.0,),
        Container(alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            onChanged: onChanged,
            validator: validator,
            obscureText: obscure,
            keyboardType: inputType,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  icon,
                  color: Colors.white,
                ),
                hintText: hintText,
                hintStyle: kHintTextStyle
            ),
          ),
        )
      ],
    );
  }
}