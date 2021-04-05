import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:integradora/src/pages/login.dart';

import './routes.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hola',
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      theme: ThemeData(
        fontFamily: 'FreeSans',
      ),
      routes: routes(context),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                LoginPage()); // Cambialo a un Splash
      },
    );
  }
}
