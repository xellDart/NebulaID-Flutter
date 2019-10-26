import 'package:flutter/material.dart';
import 'package:nebula_id/utils/storage.dart';

typedef OnCountry(String country);

class SponsorsDropDown extends StatefulWidget {
  final List<String> sponsors;
  final OnCountry action;
  final String title;
  final double width;

  SponsorsDropDown(
      {Key key, this.sponsors, this.action, this.title, this.width})
      : super(key: key);
  final Storage shared = new Storage();

  @override
  SponsorsDropDownState createState() => SponsorsDropDownState();
}

class SponsorsDropDownState extends State<SponsorsDropDown> {
  String current;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: new Container(
            color: Colors.white,
            width: widget.width,
            height: 45,
            child: new Padding(
              padding: EdgeInsets.all(6.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    value: current,
                    items: widget.sponsors.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    hint: Text(widget.title,
                        style: TextStyle(color: Colors.grey[700])),
                    onChanged: (String sponsor) {
                      widget.action(sponsor);
                      current = sponsor;
                      setState(() {});
                    }),
              ),
            )));
  }
}
