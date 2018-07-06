import 'package:flutter/material.dart';
import '../util/swidgetUtil.dart';
import '../ble/bleController.dart';

class ColorSelectPage extends StatefulWidget {
  @override
  ColorSelectPageState createState() => ColorSelectPageState();
}


class ColorSelectPageState extends State<ColorSelectPage> with WidgetsBindingObserver {

  double _redValue = 255.0;
  double _greenValue = 255.0;
  double _blueValue = 255.0;

  bool _randomModeEnabled = false;


  final TextStyle _textStyle = new TextStyle(
    color: Colors.white,
    fontSize: 20.0,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state) {
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        activateBluetoothService();
        activateLocationService();
        break;
      case AppLifecycleState.suspending:
        break;
    }
  }

  _switchRandomMode() {
    if (_randomModeEnabled) {
      BleController().disableRandomMode();
    } else {
      BleController().enableRandomMode(30, 100);
    }
    setState(() => _randomModeEnabled = !_randomModeEnabled);
  }

  _renderSlider(value, onChange) {
    var activeColor = _randomModeEnabled ? Colors.grey : Colors.red;

    return new Slider(
      min: 0.0, 
      max: 255.0, 
      divisions: 128,
      activeColor: activeColor,
      inactiveColor: Colors.grey,
      onChanged: (value) {
        if (!_randomModeEnabled) {
          onChange(value);
          BleController().writeValue(_redValue.toInt(), _greenValue.toInt(), _blueValue.toInt());
        }
      },
      value: value,
    );
  }
 
  _renderRandomModeButton() {
    return new Center(
      child: new Container(
        padding: new EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
        child: new FlatButton(
          onPressed: () => _switchRandomMode(),
          child: new Container(
            padding: new EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
            child: new Text(_randomModeEnabled ? "Disable Random Mode" : "Enable Random Mode",
              style: _textStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

    _renderSaveButton() {
    return new Center(
      child: new Container(
        padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
        child: new FlatButton(
          onPressed: () => BleController().saveColor(),
          child: new Container(
            padding: new EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
            child: new Text("Save Color",
              style: _textStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.blueAccent,
      child: new Center(
        child: new Container(
          padding: new EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _renderSaveButton(),
              _renderRandomModeButton(),
              new Text("Red:", style: _textStyle),
              _renderSlider(_redValue, (value) => setState(() => _redValue = value)),
              new Text("Gree:", style: _textStyle),
              _renderSlider(_greenValue, (value) => setState(() => _greenValue = value)),
              new Text("Blue:", style: _textStyle),
              _renderSlider(_blueValue, (value) => setState(() => _blueValue = value)),
            ],
          ),
        ),
      ),
    );
  }
}