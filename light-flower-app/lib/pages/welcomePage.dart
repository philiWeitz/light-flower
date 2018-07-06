import 'package:flutter/material.dart';
import '../util/swidgetUtil.dart';
import '../ble/bleController.dart';

class WelcomePage extends StatefulWidget {
  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {

  bool _isLoading = false;

  final TextStyle _welcomeTextStyle = new TextStyle(
    color: Colors.white,
    fontSize: 30.0
  );

  final BoxDecoration _welcomeBoxDecoration = new BoxDecoration(
    border: new Border.all(
      color: Colors.white,
      width: 5.0,
    )
  );

  @override
  void initState() {
    super.initState();
    BleController().init();

    activateBluetoothService();
    activateLocationService();
  }

  _onConnectToDeviceSuccessful() {
    Navigator.of(context).pushNamed('/color');
    setState(() => _isLoading = false);
  }

  _onConnectToDeviceError() {
    _showErroDialog("Unable to connect to tree",
      "Please try to disconnect the tree from the power source and connect it again");
  }

  _onPress(BuildContext context) {
    if (BleController().isConnected()) {
      Navigator.of(context).pushNamed('/color');
      return;
    }

    setState(() => _isLoading = true);
    BleController().scanForDevices((device) {
      BleController().stopScanning();
      // connect to device
      BleController().connectToDevice(device,
        _onConnectToDeviceSuccessful, _onConnectToDeviceError);
    }, () {
      _showTreeNotFoundAltertDialog();
    });
  }


  _showTreeNotFoundAltertDialog() {
    _showErroDialog("Tree not found", "Please connect the power to the tree and try again.");
  }


  _showErroDialog(String title, String content) {
    AlertDialog dialog = AlertDialog(
      title: new Text("Tree not found"),
      content: new Text("Please connect the power to the tree and try again."),
      actions: <Widget>[
        new FlatButton(onPressed: () => Navigator.pop(context), child: new Text("OK")),
      ],
    );
    
    showDialog(context: context, child: dialog);
    setState(() => _isLoading = false);
  }


  _renderLoading() {
    return new Center(
      child: new Container(
        padding: new EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation(Colors.white)),
      )
    );
  }


  _renderConnectButton() {
    return new InkWell(
      onTap: () => _onPress(context),
      child: new Center(
        child: new Container(
          padding: new EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          decoration: _welcomeBoxDecoration,
          child: new Text("Connect",
            style: _welcomeTextStyle
          ),
        ),
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.blueAccent,
      child: _isLoading ? _renderLoading() : _renderConnectButton(),
    );
  }
}