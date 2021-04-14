import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:integradora/src/pages/login.dart';

import './routes.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArduRemote',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en', ""),
        const Locale('es', ""),
      ],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> suppotedLocales) => locale,
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      theme: ThemeData(
        fontFamily: 'FreeSans',
        primaryColor: Colors.black,
        accentColor: Colors.black,
      ),
      routes: routes(context),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext context) => LoginPage(),
        );
      },
    );
  }
}
