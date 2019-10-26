import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:nebula_id/machine/documents/document.dart';
import 'package:nebula_id/presenter/presenter.dart';
import 'package:nebula_id/utils/documents.dart';
import 'package:nebula_id/utils/dropdown.dart';
import 'package:nebula_id/utils/storage.dart';

typedef void OnCountry(String country);
typedef void OnComplete(Map<String, dynamic> country);

class DocumentRegister extends StatefulWidget {
  final String next;
  final String title;
  final Color buttonColor;
  DocumentRegister({Key key, this.next, this.title, this.buttonColor})
      : super(key: key);

  @override
  DocumentRegisterState createState() => DocumentRegisterState();
}

class DocumentRegisterState extends State<DocumentRegister>
    with AfterLayoutMixin<DocumentRegister>
    implements APIResult {
  final shared = new Storage();
  bool inCountry = false;
  bool inDocument = false;
  bool isComplete = false;
  bool isVerification = false;
  bool isOne = false;
  int retries = 0;
  String currentCountry;
  String currentDocument;
  String missingDocument;
  VoidCallback complete;
  List<String> docs;
  Map dataImages;
  List<Map<dynamic, dynamic>> documents = [];

  String next = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) => initDocuments();

  initDocuments() async {
    next = widget.next;
    documents = await FilterDocument(context: context).getList(null, null);
  }

  void onCountry(String country) {
    this.currentCountry = country;
    ApiPresenter.country(this, {'country': country}).setCountry();
    for (Map element in documents) {
      if (element['country'] == country) {
        docs = element['documents'];
        setState(() {
          inCountry = true;
        });
        break;
      }
    }
  }

  void onComplete(Map data) => setState(() {
        isComplete = true;
        dataImages = data;
      });

  void onDocuments(String doc) {
    isOne = doc == 'Passport' ? true : false;
    setState(() {
      isComplete = false;
      currentDocument = doc;
      inDocument = true;
    });
  }

  void sendImages() {}

  @override
  Widget build(BuildContext context) {
    Widget rem = Text('');
    Widget float = FloatingActionButton.extended(
        onPressed: sendImages,
        backgroundColor: widget.buttonColor,
        icon: Icon(Icons.navigate_next),
        label: Text(next));
    if (inDocument)
      rem = REM(
          color: widget.buttonColor,
          complete: onComplete,
          inOne: isOne,
          doc: currentDocument,
          country: currentCountry);
    Widget document = Text('');
    if (inCountry)
      document = SponsorsDropDown(
          sponsors: docs,
          action: onDocuments,
          width: 260.0,
          title: 'Select document');
    else
      document = Text('');
    return new Scaffold(
        floatingActionButton: isComplete == true ? float : null,
        body: new Container(
          width: double.infinity,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 20.0, bottom: 10.0),
                child: new Text('title document',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF2c3e50))),
              ),
              new Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 15),
                child: new Text('Select country',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF2c3e50))),
              ),
              SponsorsDropDown(sponsors: [
                'Mexico',
                'EUA',
              ], width: 260.0, action: onCountry, title: 'Country'),
              new Padding(
                padding: EdgeInsets.all(10),
                child: document,
              ),
              rem
            ],
          ),
        ));
  }

  @override
  void onError(DioError err) {
    // TODO: implement onError
  }

  @override
  void onResult(value) {
    // TODO: implement onResult
  }
}
