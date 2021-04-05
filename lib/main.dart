import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'src/myapp.dart';

void main() => {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      )),
      runApp(MyApp())
    };
