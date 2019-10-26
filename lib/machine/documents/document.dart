import 'dart:convert';
import 'dart:io';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nebula_id/machine/documents/select_document.dart';
import 'package:nebula_id/utils/item_list.dart';
import 'package:nebula_id/utils/separator.dart';
import 'package:nebula_id/utils/storage.dart';

class REM extends StatefulWidget {
  final OnComplete complete;
  final bool inOne;
  final String doc;
  final String country;
  final Color color;

  REM({Key key, this.complete, this.inOne, this.doc, this.country, this.color})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return REMState();
  }
}

class REMState extends State<REM>
    with TickerProviderStateMixin, AfterLayoutMixin<REM> {
  bool inFront = false;
  bool inBack = false;
  bool isLoading = false;
  Image imageFront;
  Image imageBack;
  String b64imageFront;
  String b64imageBack;
  String titleFront = '';
  String done = '';
  String titleBack = '';
  Color currentColorFrontal = Colors.blueGrey[200];
  Color currentColorBack = Colors.blueGrey[200];

  //Help
  List<int> imageBytes = new List();
  bool reset = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      titleBack = 'Pending';
      titleFront = 'Pending';
      done = 'Done';
    });
  }

  Widget onlyOne() {
    return new Column(
      children: <Widget>[
        new Separator(
            title:
            'Front of ${widget.doc}'),
        GestureDetector(
            onTap: () => takeImage(true),
            child: new ItemList(
              title: titleFront,
              summary:
              'Front of ${widget.doc}',
              icon: Icons.check_box,
              color: currentColorFrontal,
            )),
      ],
    );
  }

  Widget onlyTwo() {
    return new Column(
      children: <Widget>[
        new Separator(
            title:
            'Front of ${widget.doc}'),
        GestureDetector(
            onTap: () => takeImage(true),
            child: new ItemList(
              title: titleFront,
              summary:
              'Front image of your ${widget.doc}',
              icon: Icons.check_box,
              color: currentColorFrontal,
            )),
        new Separator(
            title:
            'Back of ${widget.doc}'),
        GestureDetector(
            onTap: () => takeImage(false),
            child: new ItemList(
              title: titleBack,
              summary:
              'Back image of ${widget.doc}',
              icon: Icons.check_box,
              color: currentColorBack,
            )),
      ],
    );
  }

  Widget getTextOne() {
    return new RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'Nebula ',
            style: TextStyle(
                color: widget.color, fontWeight: FontWeight.bold),
          ),
          TextSpan(
              text: 'Take front image:\n',
              style: TextStyle(color: Color(0xFF2c3e50))),
          TextSpan(
              text:
              'Take front image of rour document and${widget.doc}\n',
              style: TextStyle(color: Color(0xFF2c3e50))),
        ],
      ),
    );
  }

  Widget getTextTwo() {
    return new RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'REM ',
            style: TextStyle(
                color: widget.color, fontWeight: FontWeight.bold),
          ),
          TextSpan(
              text:
              'Front of ${widget.doc}:\n',
              style: TextStyle(color: Color(0xFF2c3e50))),
          TextSpan(
              text:
              'Take front image of ${widget.doc}\n',
              style: TextStyle(color: Color(0xFF2c3e50))),
          TextSpan(
              text:
              'Take back image of ${widget.doc}\n',
              style: TextStyle(color: Color(0xFF2c3e50))),
        ],
      ),
    );
  }

  call() {
    if (!widget.inOne) {
      if (inFront && inBack)
        widget.complete({
          'frontImage': b64imageFront,
          'backImage': b64imageBack,
          'name': widget.doc,
          'reset': reset
        });
    } else {
      if (inFront)
        widget.complete(
            {'frontImage': b64imageFront, 'name': widget.doc, 'reset': reset});
    }
  }

  takeImage(bool mode) async {
    File img = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 760.0, maxWidth: 560.0);
    if (await Storage().getString('reset') != null) {
      reset = true;
      Storage().deleteString('reset');
    }
    if (img != null) {
      imageBytes = await img.readAsBytes();
      if (mode) {
        imageFront = new Image.file(img, height: 60);
        b64imageFront = base64Encode(imageBytes);
        setState(() {
          currentColorFrontal = Colors.teal;
          titleFront = done;
          inFront = true;
        });
      } else {
        imageBack = Image.file(img, height: 60);
        setState(() {
          currentColorBack = Colors.teal;
          b64imageBack = base64Encode(imageBytes);
          titleBack = done;
          inBack = true;
        });
      }
      call();
    }
    /*if (img != null) {
      TextExtract a = await TextExtract(
              this, img, mode, widget.doc, widget.country, context)
          .init();
      a.getText();
    }*/
  }

  Widget buildImagePreview(String title, Image img) {
    return new Card(
      child: new Column(children: <Widget>[
        img,
        new Padding(
            padding: new EdgeInsets.all(7.0),
            child: new Row(
              children: <Widget>[
                new Text(title, style: new TextStyle(fontSize: 12.0))
              ],
            ))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget data = Text('');
    data = isLoading
        ? Center(
        child: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: CircularProgressIndicator()))
        : getInsert();
    return data;
  }

  Widget getInsert() {
    Widget front = Text('');
    Widget back = Text('');
    Widget send = Text('');
    Widget selections = Text('');
    if (inFront)
      front = Padding(
        padding: EdgeInsets.all(10),
        child: buildImagePreview('Front', imageFront),
      );
    if (inBack)
      back = Padding(
        padding: EdgeInsets.all(10),
        child: buildImagePreview('Back', imageBack),
      );
    selections = widget.inOne == true ? onlyOne() : onlyTwo();
    return new Expanded(
        child: new Center(
          child: new Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  child: widget.inOne == true ? getTextOne() : getTextTwo()),
              new Expanded(
                  child: new ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      selections,
                      new Separator(title: 'Images'),
                      new Container(
                        color: Colors.white,
                        height: 116,
                        child: new Row(children: <Widget>[front, back]),
                      ),
                      send
                    ],
                  ))
            ],
          ),
        ));
  }
}
