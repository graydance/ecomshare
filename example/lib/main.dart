import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ecomshare/ecomshare.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> _supportedChannels = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    List<String> platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion =
          await Ecomshare.getSupportedChannels(Ecomshare.MEDIA_TYPE_IMAGE);
    } on PlatformException {
      platformVersion = [];
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _supportedChannels = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ecomshare example app'),
        ),
        body: Center(
          child: Column(
            children: _supportedChannels
                .map((channel) => RaisedButton(
                      onPressed: () async {
                        try {
                          File file = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          await Ecomshare.shareTo(
                              Ecomshare.MEDIA_TYPE_IMAGE, channel, file.path);
                        } on PlatformException catch (err) {
                          print(err);
                        } catch (ex) {
                          print(ex);
                        }
                      },
                      child: Text(channel),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
