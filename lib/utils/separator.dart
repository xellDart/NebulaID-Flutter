import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  final String title;
  Separator({
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Container(
          width: double.infinity,
          height: 30.0,
          decoration: new BoxDecoration(
              color: Color(0xFFF8F8F8)
          ),
          child: new Padding(
            padding: EdgeInsets.only(top: 9.0, left: 8.0),
            child: new Text(title, style: new TextStyle(color: Color(0xFF222F3F), fontWeight: FontWeight.w500, fontSize: 11.0)),
          ),

        ),
      ],
    );
  }
}
