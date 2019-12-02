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
    this._user = user;
  }

  getUUID() => new User(this.nebula).createUser();

  getToken() {
    auth = new Auth(
        nebula: nebula,
        company: this._company,
        encrypt: this._integration,
        secret: this._secret,
        user: this._user);
    auth.getToken();
  }

  createAccess(String uuid) => access = new Access(uuid);

  Future<List<Map>> getDocuments() async {
    return await FilterDocument().getList();
  }

  analiseDocuments(List<String> images, String type, String country,
          OnDocumentSaved onDocumentSaved, OnDocumentError onDocumentError) =>
      AnaliseDocument(nebula: nebula, saved: onDocumentSaved, error: onDocumentError)
          .processDocument(images, type, country);

  getDocument(OnDocumentGet onDocumentGet, OnDocumentError onDocumentError) =>
      AnaliseDocument(nebula: nebula, get: onDocumentGet, error: onDocumentError).getDocument();

  Widget faceUUID(
      String title,
      String subtitle,
      String extra,
      String toRight,
      String toLeft,
      String closeEyes,
      String takePhoto,
      Widget bottom,
      List<List<Color>> colors,
      OnFaceDone onFaceDone,
      OnFaceError onFaceError) {
    return new Face(
        title: title,
        subtitle: subtitle,
        extra: extra,
        toRight: toRight,
        toLeft: toLeft,
        closeEyes: closeEyes,
        takePhoto: takePhoto,
        nebula: nebula,
        done: onFaceDone,
        error: onFaceError,
        colors: colors,
        bottom: bottom);
  }
}
