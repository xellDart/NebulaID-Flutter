import 'package:flutter/material.dart';
import 'package:nebula_id/auth/auth.dart';
import 'package:nebula_id/machine/face/face_life.dart';
import 'package:nebula_id/user/user.dart';

import 'machine/documents/select_document.dart';

class NebulaId {
  final String company;
  final String secret;
  final String integration;
  final String user;
  static Auth auth;

  NebulaId({this.company, this.secret, this.integration, this.user}) {
    auth = new Auth(
        company: company,
        encrypt: integration,
        secret: secret,
        user: this.user);
    auth.setToken();
  }

  Widget analyzeDocument(String next, String title, Color buttonColor) {
    return new DocumentRegister(
        next: next, title: title, buttonColor: buttonColor);
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
