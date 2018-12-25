import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter_bridge/flutter_bridge.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // getAppDocumentsDirectory();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("WebView 加载本地 Html")),
        body: WebView(
          onWebCreated: onWebCreated
        ),
      ),
    );
  }

  void onWebCreated(webController) {
    webController.loadUrl("assets/index.html");
  }
}
