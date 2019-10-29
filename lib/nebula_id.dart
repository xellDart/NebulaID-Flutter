import 'package:flutter/material.dart';
import 'package:nebula_id/auth/auth.dart';
import 'package:nebula_id/machine/face/face_life.dart';
import 'package:nebula_id/model/nebula.dart';
import 'package:nebula_id/user/user.dart';
import 'package:nebula_id/utils/documents.dart';

import 'machine/documents/select_document.dart';

class NebulaId {
  String _company;
  String _secret;
  String _integration;
  String _user;

  final Nebula nebula;
  static Access access;
  static Auth auth;

  NebulaId({this.nebula});

  setCredentials(
      String company, String secret, String integration, String user) {
    this._company = company;
    this._secret = secret;
    this._integration = integration;
    this._secret = secret;
  }

  getUUID() => new User(this.nebula).createUser();

  getToken() {
    auth = new Auth(
        company: this._company,
        encrypt: this._integration,
        secret: this._secret,
        user: this._user);
    auth.getToken();
  }

  createAccess(String uuid) =>
    access = new Access(uuid);

  Future<List<Map>> getDocuments() async {
    return await FilterDocument().getList();
  }

  analiseDocuments(List<String> images, String type, String country) =>
      AnaliseDocument().processDocument(images, type, country);

  getDocument() => AnaliseDocument().getDocument();

  Widget faceUUID(
      String title,
      String subtitle,
      String extra,
      String toRight,
      String toLeft,
      String closeEyes,
      String takePhoto,
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
        nebula: nebula,
        colors: colors,
        bottom: bottom);
  }
}
