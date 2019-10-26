import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  final String title;
  final String summary;
  final IconData icon;
  final Color color;
  ItemList({this.title, this.summary, this.icon, this.color});
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 66.0,
      decoration: new BoxDecoration(color: Colors.white),
      child: new Row(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: new Icon(icon, color: color ?? const Color(0xFF808e9b)),
          ),
          new Padding(
            padding: EdgeInsets.only(left: 5.0, top: 12.0),
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(title,
                      style: new TextStyle(
                          color: const Color(0xFF57606f), fontSize: 12.0)),
                  new Padding(
                      padding: EdgeInsets.only(top: 3.0, right: 0.0),
                      child: SizedBox(
                        width: 285,
                        child: Text(summary),
                      ))
                ]),
          )
        ],
      ),
    );
  }
}
