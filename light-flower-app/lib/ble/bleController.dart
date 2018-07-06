import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue/flutter_blue.dart';

typedef void OnScanResult(BluetoothDevice device);
typedef void OnScanStop();
typedef void OnResult();

class BleController {
  static final BleController _bleController = new BleController._internal();
  static FlutterBlue _flutterBlue;

  factory BleController() {
    return _bleController;
  }

  BluetoothDevice _device;
  BluetoothCharacteristic _characteristic;
  StreamSubscription _scanSubscription;
  StreamSubscription _deviceConnection;
  Timer _scanTimoutTimer;

  init() {
    // get an instance
    _flutterBlue = FlutterBlue.instance;
    print('BLE instance created');
  }

  scanForDevices(OnScanResult onScanResult, OnScanStop onScanStop) {
    print('Started scanning...');
    _scanSubscription = _flutterBlue.scan().listen((scanResult) {
      if (scanResult.device.name == "HMSoft") {
        onScanResult(scanResult.device);
      }
    });

    _scanTimoutTimer = new Timer(Duration(seconds: 3), () {
      stopScanning();
      onScanStop();
      print('Started stoped');
    });
  }

  stopScanning() {
    _scanTimoutTimer?.cancel();
    _scanSubscription?.cancel();
    _scanSubscription = null;
  }

  connectToDevice(BluetoothDevice device, OnResult onSuccess, OnResult onError) {
    _device = device;
    _deviceConnection = _flutterBlue.connect(device).listen((s) async {
      if(s == BluetoothDeviceState.connected) {
        print("Connected");
        List<BluetoothService> services = await device.discoverServices();

        services.forEach((service) async {
          var characteristics = service.characteristics;
          for(BluetoothCharacteristic c in characteristics) {
            print(c.uuid.toString());
            if (c.uuid.toString() == "0000ffe1-0000-1000-8000-00805f9b34fb") {
              print("Characteristic safed");
              _characteristic = c;
              onSuccess();
              break;
            }
          }
          if (null == _characteristic) {
            onError();
          }
        });
      } else {
        onError();
      }
    });
  }

  disconnect() {
    _deviceConnection?.cancel();
    _deviceConnection = null;
  }

  isConnected() {
    return _deviceConnection != null;
  }

  writeValue(int red, int green, int blue) async {
    await _device.writeCharacteristic(_characteristic, utf8.encode("COLOR,R,$red\$"));
    await _device.writeCharacteristic(_characteristic, utf8.encode("COLOR,G,$green\$"));
    await _device.writeCharacteristic(_characteristic, utf8.encode("COLOR,B,$blue\$"));
  }

  enableRandomMode(delay, minValue) async {
    await _device.writeCharacteristic(_characteristic, utf8.encode("RAND,START,$delay,$minValue\$"));
  }

  disableRandomMode() async {
    await _device.writeCharacteristic(_characteristic, utf8.encode("RAND,STOP\$"));
  }

  saveColor() async {
    await _device.writeCharacteristic(_characteristic, utf8.encode("SAVE,COLOR\$"));
  }

  BleController._internal();
}