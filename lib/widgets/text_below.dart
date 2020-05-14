import 'package:flutter/material.dart';

class TextBelow extends StatelessWidget {

  final Function func;
  final String text1;
  final String text2;

  const TextBelow({@required this.func, @required this.text1, @required this.text2});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: RichText(
        text: TextSpan(children: [
          TextSpan(text: text1,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400
            ),
          ),
          TextSpan(text: text2,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
              ))
        ]),
      ),
    );
  }
}