import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:nebula_id/machine/face/face_life.dart';

class NebulaId {

  Widget faceUUID(
      List<CameraDescription> cameras,
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
      cameras: cameras,
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
