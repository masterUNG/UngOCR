import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

class ReadOcr extends StatefulWidget {
  @override
  _ReadOcrState createState() => _ReadOcrState();
}

class _ReadOcrState extends State<ReadOcr> {
  // Filed
  Size size;
  String result;
  List<OcrText> ocrTexts = List();
  TextEditingController searchController = TextEditingController();

  // Method
  @override
  void initState() {
    super.initState();
    FlutterMobileVision.start().then((previewSizes) => setState(() {
          size = previewSizes[FlutterMobileVision.CAMERA_BACK].first;
        }));
  }

  Future<Null> processReadOCR() async {
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
        flash: true,
        autoFocus: true,
        multiple: true,
        waitTap: true,
        showText: true,
        preview: size,
        camera: FlutterMobileVision.CAMERA_BACK,
        fps: 2.0,
      );
      print('texts ===>>> ${texts.toString()}');
    } on Exception {
      texts.add(new OcrText('Failed to recognize text.'));
    }

    if (!mounted) return;

    setState(() => ocrTexts = texts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              searchField(),
              readOCRbutton(),
            ],
          ),
        ],
      ),
    );
  }

  TextField searchField() {
    if (ocrTexts.length != 0) {
      setState(() {
        result = ocrTexts[0].value;
        print('result =====>>> $result');
        searchController.text = result;
      });
    }

    return TextField(
      controller: searchController,
    );
  }

  RaisedButton readOCRbutton() {
    return RaisedButton(
      onPressed: () {
        processReadOCR();
      },
      child: Text('readOCR'),
    );
  }
}
