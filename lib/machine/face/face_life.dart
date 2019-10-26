import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:nebula_id/paints/circle.dart';
import 'package:nebula_id/presenter/presenter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:ui';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:random_string/random_string.dart';
import 'package:vibration/vibration.dart';

typedef OnResultFace(String uuid);

class Face extends StatefulWidget {
  final String title;
  final String subtitle;
  final String extra;
  final String toRight;
  final String toLeft;
  final String closeEyes;
  final String takePhoto;
  final OnResultFace resultFace;
  final List<List<Color>> colors;
  final Widget bottom;

  Face(
      {Key key,
      this.title,
      this.subtitle,
      this.extra,
      this.toRight,
      this.toLeft,
      this.closeEyes,
      this.takePhoto,
      this.resultFace,
      this.colors,
      this.bottom})
      : super(key: key);

  @override
  FaceState createState() => FaceState();
}

class FaceState extends State<Face>
    with TickerProviderStateMixin, WidgetsBindingObserver
    implements APIResult {
  double percentage = 0.0;
  double newPercentage = 0.0;
  int retries = 0;
  AnimationController percentageAnimationController;
  bool isDetecting = false;
  bool isEyesClose = false;
  bool isFaceAngleRightDone = false;
  bool inStream = true;
  bool isFaceAngleLeftDone = false;

  String toRight;
  String toLeft;
  String closeEyes;
  String takeImage;

  String onTextPress;

  int baseColorCount = 1;
  Color actualBack = Color(0xFFd2dae2);
  Color actualFront = Color(0xFF4bcffa);
  List<List<Color>> colorsCircle;

  // Camera declarations
  List<String> photos = new List();
  CameraController controller;
  String imagePath;

  List<CameraDescription> cameras;

  final FaceDetector detector = FirebaseVision.instance.faceDetector(
    FaceDetectorOptions(
      enableClassification: true,
      mode: FaceDetectorMode.accurate,
    ),
  );

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    cameras = await availableCameras();
    onCameraSelected(cameras[1]);
    setState(() {
      percentage = 0.0;
      colorsCircle = widget.colors;
    });
    percentageAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000))
      ..addListener(() {
        setState(() {
          percentage = lerpDouble(
              percentage, newPercentage, percentageAnimationController.value);
        });
      });
    WidgetsBinding.instance.addObserver(this);
  }

  initText() {
    toRight = widget.toRight;
    toLeft = widget.toLeft;
    closeEyes = widget.closeEyes;
    takeImage = widget.takePhoto;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.stopImageStream();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onCameraSelected(cameras[1]);
      }
    }
  }

  @override
  void onResult(value) => widget.resultFace(value);

  @override
  void onError(DioError err) {
    print(err.message);
    //err.response.data['message']
  }

  Widget cameraWidget() {
    return new AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: new ClipRRect(
          borderRadius: new BorderRadius.circular(125.0),
          child: new CameraPreview(controller),
        ));
  }

  sendPhoto() {
    ApiPresenter.face(this, {
      'images': photos.sublist(0, 2),
    }).saveFace();
  }

  capture() => takePicture().then((String filePath) {
        if (mounted)
          setState(() {
            imagePath = filePath;
          });
        if (filePath != null) setCameraResult();
      });

  tap() async {
    if (isEyesClose) {
      if (inStream) {
        await controller.stopImageStream();
        inStream = false;
      }
      setState(() {
        percentage = newPercentage;
        newPercentage += 25;
        actualBack = colorsCircle[baseColorCount][0];
        actualFront = colorsCircle[baseColorCount][1];
        baseColorCount++;
      });
      capture();
      if (newPercentage > 100.0) {
        baseColorCount = 1;
        actualBack = colorsCircle[0][0];
        actualFront = colorsCircle[0][1];
        percentage = 0.0;
        newPercentage = 0.0;
        sendPhoto();
      }
      percentageAnimationController.forward(from: 0.0);
    }
  }

  Future<void> startStream() async {
    await controller.startImageStream((CameraImage image) {
      if (isDetecting) return;
      isDetecting = true;
      runDetection(image);
      setState(() {});
    });
  }

  void onCameraSelected(CameraDescription cameraDescription) async {
    controller = CameraController(cameraDescription, ResolutionPreset.low,
        enableAudio: false);
    await controller.initialize();
    setState(() {});
    startStream();
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      return null;
    }
    Directory tempDir = await getTemporaryDirectory();
    final String filePath = '${tempDir.path}/${randomAlpha(5)}.jpg';
    if (controller.value.isTakingPicture) return null;
    await controller.takePicture(filePath);
    return filePath;
  }

  void setCameraResult() async {
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(imagePath);
    File compressedFile = await FlutterNativeImage.compressImage(imagePath,
        quality: 90,
        targetWidth: 310,
        targetHeight: (properties.height * 310 / properties.width).round());
    List<int> imageBytes = compressedFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    photos.add(base64Image);
  }

  @override
  Widget build(BuildContext context) {
    initText();
    if (!controller.value.isInitialized) return Container();
    setState(() {
      onTextPress = toLeft;
    });

    if (isFaceAngleLeftDone)
      setState(() {
        onTextPress = toRight;
      });

    if (isFaceAngleRightDone)
      setState(() {
        onTextPress = closeEyes;
      });

    if (isEyesClose)
      setState(() {
        onTextPress = takeImage;
      });

    double topHeight = MediaQuery.of(context).size.height / 3.8;
    if (cameras.isEmpty) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Text(
          'No Camera Found',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white
          )
        )
      );
    }
    return new Center(
      child: new Column(
        children: <Widget>[
          new Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, bottom: 20.0, top: 20.0),
              child: Text(widget.subtitle,
                  textAlign: TextAlign.center,
                  style: new TextStyle(color: Colors.grey[700]))),
          new Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, bottom: topHeight - 130),
              child: Text(onTextPress,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500))),
          new Center(
            child: new Container(
              height: topHeight,
              width: topHeight,
              child: new CustomPaint(
                  foregroundPainter: new Circle(
                      lineColor: actualBack,
                      completeColor: actualFront,
                      completePercent: percentage,
                      width: 10.0),
                  child: GestureDetector(
                    onTap: controller != null &&
                            controller.value.isInitialized &&
                            !controller.value.isRecordingVideo
                        ? tap
                        : null,
                    child: cameraWidget()
                  ))
            )
          ),
          Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: widget.extra,
                        style: TextStyle(color: Colors.grey[700]))
                  ]
                )
              )),
          widget.bottom
        ],
      ),
    );
  }

  void runDetection(CameraImage image) async {
    final int numBytes =
        image.planes.fold(0, (count, plane) => count += plane.bytes.length);
    final Uint8List allBytes = Uint8List(numBytes);

    int nextIndex = 0;
    for (int i = 0; i < image.planes.length; i++) {
      allBytes.setRange(nextIndex, nextIndex + image.planes[i].bytes.length,
          image.planes[i].bytes);
      nextIndex += image.planes[i].bytes.length;
    }

    try {
      var faces = await detector.processImage(
        FirebaseVisionImage.fromBytes(
          allBytes,
          FirebaseVisionImageMetadata(
              rawFormat: image.format.raw,
              size: Size(image.width.toDouble(), image.height.toDouble()),
              rotation: ImageRotation.rotation270,
              planeData: image.planes
                  .map((plane) => FirebaseVisionImagePlaneMetadata(
                        bytesPerRow: plane.bytesPerRow,
                        height: plane.height,
                        width: plane.width,
                      ))
                  .toList())
        ),
      );
      if (faces.isNotEmpty) checkBiometricRotateLeft(faces[0]);
    } catch (exception) {
      print(exception);
    } finally {
      isDetecting = false;
    }
  }

  checkBiometricRotateLeft(face) {
    if (!isFaceAngleLeftDone) {
      if (Platform.isIOS) {
        if (face.headEulerAngleZ > 15) {
          Vibration.vibrate(duration: 500);
          setState(() {
            isFaceAngleLeftDone = true;
          });
        }
      } else {
        if (face.headEulerAngleZ < -15) {
          Vibration.vibrate(duration: 500);
          setState(() {
            isFaceAngleLeftDone = true;
          });
        }
      }
    } else
      checkBiometricRotateRight(face);
  }

  checkBiometricRotateRight(face) {
    if (!isFaceAngleRightDone) {
      if (Platform.isIOS) {
        if (face.headEulerAngleZ < -15) {
          Vibration.vibrate(duration: 500);
          setState(() {
            isFaceAngleRightDone = true;
          });
        }
      } else {
        if (face.headEulerAngleZ > 15) {
          Vibration.vibrate(duration: 500);
          setState(() {
            isFaceAngleRightDone = true;
          });
        }
      }
    } else if (isEyesClose == false) checkBiometricEyes(face);
  }

  checkBiometricEyes(face) {
    if (isFaceAngleLeftDone && isFaceAngleRightDone) {
      try {
        bool isLeftEyeClose = face.leftEyeOpenProbability < 0.3;
        bool isRightEyeClose = face.rightEyeOpenProbability < 0.3;
        if (isLeftEyeClose && isRightEyeClose) {
          Vibration.vibrate(duration: 500);
          setState(() {
            isEyesClose = true;
          });
        }
      } catch (e) {}
    }
  }
}
