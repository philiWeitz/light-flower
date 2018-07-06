
import 'package:flutter/material.dart';
import 'pages/welcomePage.dart';
import 'pages/colorSelectPage.dart';


void main() => runApp(new MaterialApp(
  home: new WelcomePage(),
  routes: <String, WidgetBuilder> {
    '/color': (BuildContext context) => new ColorSelectPage(),
  },
));
