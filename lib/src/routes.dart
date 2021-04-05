import 'package:flutter/cupertino.dart';
import "package:integradora/src/pages/login.dart";
import 'package:integradora/src/pages/devices.dart';

Map<String, WidgetBuilder> routes(BuildContext ctx) {
  Map<String, WidgetBuilder> route = {
    '/': (BuildContext ctx) => LoginPage(),
    'devmenu': (BuildContext ctx) => DevicePage(),
  };

  return route;
}
