// ignore_for_file: prefer_const_constructors, unused_element, non_constant_identifier_names

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  File? _image;
  String text = '';
  Future _pickImage(ImageSource souce) async {
    try {
      final image = await ImagePicker().pickImage(source: souce);
      if (image == null) return;
      setState(() {
        _image = File(image.path);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future textRecognition(File img) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromFilePath(img.path);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    setState(() {
      text = recognizedText.text;
    });
    print(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Recognition'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey,
                child: Center(
                    child: _image == null
                        ? const Icon(
                            Icons.add_a_photo,
                            size: 60,
                          )
                        : Image.file(_image!)),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: double.infinity,
                  height: 50,
                  color: Colors.blue,
                  child: MaterialButton(
                    onPressed: () {
                      _pickImage(ImageSource.camera).then((value) {
                        if (_image != null) {
                          textRecognition(_image!);
                        }
                      });
                    },
                    child: Text(
                      'التقط صوره من الكامير',
                      style: TextStyle(color: Colors.white, fontSize: 23),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: double.infinity,
                  height: 50,
                  color: Colors.blue,
                  child: MaterialButton(
                    onPressed: () {
                      _pickImage(ImageSource.gallery).then((value) {
                        if (_image != null) {
                          textRecognition(_image!);
                        }
                      });
                    },
                    child: Text(
                      "اختر صوره من المعرض",
                      style: TextStyle(color: Colors.white, fontSize: 23),
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              SelectableText(
                text,
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }
}
