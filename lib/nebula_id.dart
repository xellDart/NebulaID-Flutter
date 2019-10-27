import 'package:flutter/material.dart';
import 'package:nebula_id/auth/auth.dart';
import 'package:nebula_id/machine/face/face_life.dart';
import 'package:nebula_id/user/user.dart';
import 'package:nebula_id/utils/documents.dart';

import 'machine/documents/select_document.dart';

typedef OnStart();

class NebulaId {
  final String company;
  final String secret;
  final String integration;
  final String user;
  final OnStart start;
  static Auth auth;

  NebulaId({this.company, this.secret, this.integration, this.user, this.start}) {
    auth = new Auth(
        company: company,
        encrypt: integration,
        secret: secret,
        start: start,
        user: this.user);
    auth.setToken();
  }

  Future<List<Map>> getDocuments() async {
    return await FilterDocument().getList(null, null);
  }

  analiseDocuments(List<String> images, String type, String country, OnFinish finish) {
    AnaliseDocument(finish: finish).processDocument(images, type, country);
  }

  getDocument(OnDocument document) {
    AnaliseDocument(document: document).getDocument();
  }

  Widget faceUUID(
      String title,
      String subtitle,
      String extra,
      String toRight,
      String toLeft,
      String closeEyes,
      String takePhoto,
      OnResultFace resultFace,
      Widget bottom,
      List<List<Color>> colors) {
    return new Face(
        title: title,
        subtitle: subtitle,
        extra: extra,
        toRight: toRight,
        toLeft: toLeft,
        closeEyes: closeEyes,
        takePhoto: takePhoto,
        resultFace: resultFace,
        colors: colors,
        bottom: bottom);
  }
}
