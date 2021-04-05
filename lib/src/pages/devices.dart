//import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:integradora/src/pages/infoDevices.dart';
import 'package:integradora/src/pages/login.dart';
import 'package:integradora/src/pages/tvControl.dart';

import 'package:integradora/src/pages/indexControl.dart';
//import 'package:integradora/src/utils/authentication.dart';

import 'package:integradora/src/models/user.dart';

class DevicePage extends StatefulWidget {
  DevicePage(
      {Key key, Usuario usuario, String titulo, String tagTitulo, String tipo})
      : _user = usuario,
        _tipo = tipo,
        _tagTitle = tagTitulo,
        _titulo = titulo,
        super(key: key);

  final Usuario _user;
  final String _tipo;
  final String _tagTitle;
  final String _titulo;

  @override
  _DevicePageState createState() => _DevicePageState();

  static _DevicePageState of(BuildContext context) =>
      context.findAncestorStateOfType<_DevicePageState>();
}

class _DevicePageState extends State<DevicePage> {
  Usuario _user;
  String _tipo;
  String _tagTitle;
  String _titulo;

  bool _isSigningOut = false;
  bool swipe = false;
  int sensivity = 8;
  int lastChange = 0;

  final String assetName = "assets/svg/Tv.svg";

  set total(int all) => setState(() => lastChange = all);

  @override
  void initState() {
    _user = widget._user;
    _tipo = widget._tipo;
    _tagTitle = widget._tagTitle;
    _titulo = widget._titulo;

    lastChange = _user.devices[_tipo].length;

    super.initState();
  }

  Route _routeToTvPage(dynamic selectv) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 800),
      pageBuilder: (context, animation, secondaryAnimation) =>
          IndexControlPage(tv: selectv, favs: _user.favorites),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _routeCardInfoPage() {
    return PageRouteBuilder(
      opaque: false,
      transitionDuration: Duration(milliseconds: 800),
      reverseTransitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => CardInfo(
        usuario: _user,
        tipo: _tipo,
        titulo: _titulo,
        tagTitulo: _tagTitle,
        callback: (val) => setState(() => lastChange = val),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle style = Theme.of(context).textTheme.title.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        );

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      /*appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Tv',
          style: TextStyle(
            fontSize: 26,
            color: Colors.black,
          ),
        ),
      ),*/
      /*appBar: PreferredSize(
        child: Container(
          child: ClipRRect(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: <Widget>[
                    Hero(
                      tag: _tagTitle,
                      child: Text(
                        _titulo,
                        style: style,
                      ),
                    ),
                    Spacer(),
                    Text('Total: ${_user.devices[_tipo].length}'),
                  ],
                ),
              ),
            ),
          ),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
      ),*/
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: <Color>[Color(0xFFFEFFFF), Color(0xFFbcd7f2)],
            ),
          ),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              ListView.builder(
                itemCount: lastChange =
                    lastChange == _user.devices[_tipo].length
                        ? lastChange
                        : lastChange - 1,
                itemBuilder: (context, idx) => GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(_routeToTvPage(_user.devices[_tipo][idx]));
                  },
                  child: Container(
                    width: 5,
                    height: 80,
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(10.0),
                    child: Wrap(
                      children: <Widget>[
                        /*BackdropFilter(
                        filter: ui.ImageFilter.blur(
                          sigmaX: 10.0,
                          sigmaY: 10.0,
                        ),
                      ),*/
                        SvgPicture.asset(
                          assetName,
                          alignment: Alignment.centerLeft,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "${_user.devices[_tipo][idx]["Name"]}\nMarca\n${_user.devices[_tipo][idx]["Numbers"].length == 0 ? "Sin Numeros" : "Numeros"}",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.90),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                          blurRadius: 20,
                          offset: Offset(10, 10),
                        )
                      ],
                    ),
                  ),
                  //onTap: ,
                ),
              ),
              /*AnimatedPositioned(
              height: swipe ? MediaQuery.of(context).size.height : 200.0,
              width: MediaQuery.of(context).size.width,
              duration: const Duration(seconds: 2),
              curve: Curves.fastOutSlowIn,
              child: GestureDetector(
                onTap: () {
                  swipe = !swipe;
                },
                child: Container(
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: <Widget>[
                            Hero(
                              tag: tagTitle,
                              child: Text(
                                titulo,
                                style: style,
                              ),
                            ),
                            Spacer(),
                            Text('Total: ${devs[tipo].length}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),*/
            ],
          ),
        ),
      ),
      /*Center(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: <Color>[Color(0xFFFEFFFF), Color(0xFFbcd7f2)],
              ),
            ),
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                ListView.builder(
                  itemCount: _user.devices["Tv"].length,
                  itemBuilder: (context, idx) => GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(_routeToTvPage(_user.devices[_tipo][idx]));
                    },
                    child: Container(
                      width: 5,
                      height: 80,
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(10.0),
                      child: Wrap(
                        children: <Widget>[
                          BackdropFilter(
                            filter: ui.ImageFilter.blur(
                              sigmaX: 10.0,
                              sigmaY: 10.0,
                            ),
                          ),
                          SvgPicture.asset(
                            assetName,
                            alignment: Alignment.centerLeft,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "${_user.devices[_tipo][idx]["Name"]}\nMarca\n${_user.devices[_tipo][idx]["Numbers"].length == 0 ? "Sin Numeros" : "Numeros"}",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.40),
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.15),
                            blurRadius: 20,
                            offset: Offset(10, 10),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  height: swipe ? MediaQuery.of(context).size.height : 100.0,
                  width: MediaQuery.of(context).size.width,
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.fastOutSlowIn,
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      setState(() {
                        if (details.delta.dy > sensivity) {
                          swipe = false;
                        } else if (details.delta.dy < -sensivity) {
                          swipe = true;
                        }
                      });
                    },
                    child: Container(
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: <Widget>[
                                Hero(
                                  tag: _tagTitle,
                                  child: Text(
                                    _titulo,
                                    style: style,
                                  ),
                                ),
                                Spacer(),
                                Text('Total: ${_user.devices[_tipo].length}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )*/
      /*ListViewDevices(
        devs: _user.devices,
        tipo: _tipo,
        tagTitle: _tagTitle,
        titulo: _titulo,
      ),*/
      bottomNavigationBar: PreferredSize(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.delta.dy < sensivity)
              Navigator.of(context).push(_routeCardInfoPage());
          },
          child: Container(
            child: ClipRRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                child: Container(
                  padding: EdgeInsets.only(
                      left: 20.0, right: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: <Widget>[
                      Hero(
                        tag: _tagTitle,
                        child: Text(
                          _titulo,
                          style: style,
                        ),
                      ),
                      Spacer(),
                      Text('Total: ${_user.devices[_tipo].length}'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width, 100),
      ),
      /*bottomNavigationBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            AnimatedPositioned(
              height: swipe ? MediaQuery.of(context).size.height : 100.0,
              width: MediaQuery.of(context).size.width,
              duration: const Duration(milliseconds: 1200),
              curve: Curves.fastOutSlowIn,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  setState(() {
                    if (details.delta.dy > sensivity) {
                      swipe = false;
                    } else if (details.delta.dy < -sensivity) {
                      swipe = true;
                    }
                  });
                },
                child: Container(
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: <Widget>[
                            Hero(
                              tag: _tagTitle,
                              child: Text(
                                _titulo,
                                style: style,
                              ),
                            ),
                            Spacer(),
                            Text('Total: ${_user.devices[_tipo].length}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),*/
    );
  }
}

class ListViewDevices extends StatelessWidget {
  final dynamic devs;
  final String tipo;
  final String tagTitle;
  final String titulo;

  final String assetName = "assets/svg/Tv.svg";

  final int sensivity = 8;
  final bool swipe = false;

  ListViewDevices({
    Key key,
    this.devs,
    this.tipo,
    this.tagTitle,
    this.titulo,
  }) : super(key: key);

  Route _routeToTvPage(dynamic selectv) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          TvControlPage(tv: selectv),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle style = Theme.of(context).textTheme.title.copyWith(
          fontSize: 48,
          fontWeight: FontWeight.normal,
        );
    return Center(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: <Color>[Color(0xFFFEFFFF), Color(0xFFbcd7f2)],
          ),
        ),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            ListView.builder(
              itemCount: devs["Tv"].length,
              itemBuilder: (context, idx) => GestureDetector(
                onTap: () {
                  Navigator.of(context).push(_routeToTvPage(devs[tipo][idx]));
                },
                child: Container(
                  width: 5,
                  height: 80,
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(10.0),
                  child: Wrap(
                    children: <Widget>[
                      /*BackdropFilter(
                        filter: ui.ImageFilter.blur(
                          sigmaX: 10.0,
                          sigmaY: 10.0,
                        ),
                      ),*/
                      SvgPicture.asset(
                        assetName,
                        alignment: Alignment.centerLeft,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "${devs[tipo][idx]["Name"]}\nMarca\n${devs[tipo][idx]["Numbers"].length == 0 ? "Sin Numeros" : "Numeros"}",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.90),
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.15),
                        blurRadius: 20,
                        offset: Offset(10, 10),
                      )
                    ],
                  ),
                ),
                //onTap: ,
              ),
            ),
            /*AnimatedPositioned(
              height: swipe ? MediaQuery.of(context).size.height : 200.0,
              width: MediaQuery.of(context).size.width,
              duration: const Duration(seconds: 2),
              curve: Curves.fastOutSlowIn,
              child: GestureDetector(
                onTap: () {
                  swipe = !swipe;
                },
                child: Container(
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: <Widget>[
                            Hero(
                              tag: tagTitle,
                              child: Text(
                                titulo,
                                style: style,
                              ),
                            ),
                            Spacer(),
                            Text('Total: ${devs[tipo].length}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
