
import 'dart:async';

import 'package:flutter/services.dart';

class Ecomshare {
  static const MethodChannel _channel =
      const MethodChannel('ecomshare');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
