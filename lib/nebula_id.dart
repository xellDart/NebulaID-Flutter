import 'package:flutter/material.dart';
import 'package:nebula_id/auth/auth.dart';
import 'package:nebula_id/machine/face/face_life.dart';
import 'package:nebula_id/user/user.dart';

class NebulaId {

  final String company;
  final String token;
  final String secret;
  final String integration;
  static Auth auth;

  NebulaId({this.company, this.token, this.secret, this.integration}) {
    auth = new Auth(company: company, encrypt: integration, secret: secret);
  }

  createUser(OnUser user) {
    new User(result: user);
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
      colors: colors
    );
  }
}
