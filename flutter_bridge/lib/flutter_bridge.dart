import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:path_provider/path_provider.dart';

class FlutterBridge {
  static const MethodChannel _channel = const MethodChannel('flutter_bridge');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

typedef void WebViewCreatedCallback(WebController controller);

/// A web view widget for showing html content.
class WebView extends StatefulWidget {
  final WebViewCreatedCallback onWebCreated;

  /// Creates a new web view.
  const WebView({
    Key key,
    @required this.onWebCreated,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return GestureDetector(
          onLongPress: () {
            print("onLongPress");
          },
          child: AndroidView(
            viewType: 'plugins.flutter.io/webview',
            onPlatformViewCreated: _onPlatformViewCreated,
            creationParamsCodec: const StandardMessageCodec(),
          ));
    }
    return new Text(
        '$defaultTargetPlatform is not yet supported by this plugin');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(WebView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onWebCreated == null) {
      return;
    }
    widget.onWebCreated(new WebController.init(context, id));
  }
}

class WebController {
  MethodChannel _channel;
  BuildContext _context;

  WebController.init(BuildContext context, int id) {
    _context = context;
    _channel = new MethodChannel('plugins.flutter.io/webview_$id');
  }

  Future<void> loadUrl(String url) async {
    assert(url != null);
    String platformURL = await writeBundleAsset(url);
    return _channel.invokeMethod('loadUrl', "file://$platformURL");
  }

  // 将本地URL路径转换成平台绝对路径
  Future<String> convertPlatformURL(String url) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    return '${appDocDir.path}/$url';
  }

  // 写 BundleAsset 文件
  Future<String> writeBundleAsset(String url) async {
    if (url.startsWith(r'http(s)://')) {
      return url;
    }

    String platformURL = await convertPlatformURL(url);
    File file = await new File(platformURL);
    bool isExist = await file.exists();
    if (isExist) {
      await file.delete();
    }

    await file.create(recursive: true);
    String data = await DefaultAssetBundle.of(_context).loadString(url);
    RegExp _attr = new RegExp(
        r'([-A-Za-z0-9_]+)(?:\s*=\s*(?:(?:"((?:\\.|[^"])*)")' +
            r"|(?:'((?:\\.|[^'])*)')|([^>\s]+)))?");
    Iterable<Match> matches = _attr.allMatches(data);
    if (matches != null) {
      for (Match match in matches) {
        String attribute = match[1];
        String value;
        if (match[2] != null) {
          value = match[2];
        } else if (match[3] != null) {
          value = match[3];
        } else if (match[4] != null) {
          value = match[4];
        }

        if (attribute == "href" || attribute == "src") {
          await writeBundleAsset('assets/$value');
        }
      }
    }
    await file.writeAsString(data);

    return platformURL;
  }
}
