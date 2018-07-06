import 'dart:async';

import 'package:flutter/services.dart';

class Swidget {
  static const MethodChannel _channel =
      const MethodChannel('swidget');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get activeLocationService async {
    final String version = await _channel.invokeMethod('activateLocationService');
    return version;
  }

  static Future<String> get activeBluetoothService async {
    final String version = await _channel.invokeMethod('activateBluetoothService');
    return version;
  }
}
