import 'package:swidget/swidget.dart';


activateLocationService() async {
  await Swidget.activeLocationService;
}

activateBluetoothService() async {
  await Swidget.activeBluetoothService;
}