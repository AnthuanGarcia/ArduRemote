//import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:integradora/src/utils/gradients.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:integradora/src/pages/infoDevices.dart';
import 'package:integradora/src/pages/login.dart';
import 'package:integradora/src/pages/tvControl.dart';

import 'package:integradora/src/pages/indexControl.dart';
//import 'package:integradora/src/utils/authentication.dart';

import 'package:integradora/src/models/user.dart';

class DevicePage extends StatefulWidget {
  DevicePage(
      {Key key,
      Usuario usuario,
      String titulo,
      String tagTitulo,
      String tipo,
      String tagDegra,
      String tagBack,
      String assetName,
      List<Color> colors})
      : _user = usuario,
        _tipo = tipo,
        _tagTitle = tagTitulo,
        _titulo = titulo,
        _tagBack = tagBack,
        _tagDegra = tagDegra,
        _assetName = assetName,
        _colors = colors,
        super(key: key);

  final Usuario _user;
  final String _tipo;
  final String _tagTitle;
  final String _titulo;
  final String _tagDegra;
  final String _tagBack;
  final String _assetName;
  final List<Color> _colors;

  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  Usuario _user;
  String _tipo;
  String _tagTitle;
  String _titulo;
  String _tagDegra;
  String _tagBack;
  String _assetName;
  List<Color> _colors;
  List<int> idxRandGra;

  //bool _isSigningOut = false;
  bool swipe = false;
  int sensivity = 8;
  bool visible = false;
  //int lastChange = 0;

  bool change = false;

  ScrollController _controller;

  Map<String, String> icons = {
    'Tv': "assets/svg/Tv.svg",
    'Media': "assets/svg/media-play.svg"
  };

  String iconList;

  // set total(int all) => setState(() => lastChange = all);

  @override
  void initState() {
    _user = widget._user;
    _tipo = widget._tipo;
    _tagTitle = widget._tagTitle;
    _titulo = widget._titulo;
    _tagDegra = widget._tagDegra;
    _tagBack = widget._tagBack;
    _assetName = widget._assetName;
    _colors = widget._colors;

    //lastChange = _user.devices[_tipo].length;
    iconList = icons[_tipo];
    visible = true;

    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    idxRandGra = List.generate(_user.devices[_tipo].length,
        (i) => Random().nextInt(RandGradient.randGradients.length));

    super.initState();
  }

  _scrollListener() {
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() => {change = false});
    } else {
      setState(() => {change = true});
    }
  }

  Route _routeToTvPage(dynamic selectv, List<Color> colors) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 800),
      pageBuilder: (context, animation, secondaryAnimation) =>
          IndexControlPage(tv: selectv, favs: _user.favorites, colors: colors),
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
          fontSize: 34,
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.all(0),
          /*decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _colors,
            ),
          ),*/
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              /*Positioned(
                child: Hero(
                  tag: _tagBack,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 288,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(_assetName),
                      ),
                    ),
                  ),
                ),
              ),*/
              /*Positioned(
                child: Hero(
                  tag: _tagDegra,
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (details.delta.dy > -sensivity)
                        Navigator.of(context).pop();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 290,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _colors,
                        ),
                      ),
                    ),
                  ),
                ),
              ),*/
              Positioned(
                child: AnimatedOpacity(
                  opacity: visible ? 1.0 : 0,
                  duration: Duration(milliseconds: 800),
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (details.delta.dy > -sensivity)
                        Navigator.of(context).pop();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _colors,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              /*AnimatedContainer(
                width: change ? MediaQuery.of(context).size.width : 250,
                height: change ? MediaQuery.of(context).size.height : 400,
                margin: EdgeInsets.only(
                  top: change ? 0 : 170,
                  bottom: 0,
                ),
                duration: Duration(milliseconds: 600),
                child:*/
              Positioned(
                child: Hero(
                  tag: _tagTitle,
                  child: Card(
                    margin: EdgeInsets.all(0),
                    color: Colors.transparent,
                    shadowColor: Colors.transparent,
                    child: AnimatedContainer(
                      width: change ? MediaQuery.of(context).size.width : 250,
                      height: change ? MediaQuery.of(context).size.height : 450,
                      margin: EdgeInsets.only(
                        top: change ? 0 : 90,
                        bottom: 0,
                      ),
                      duration: Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(change ? 0 : 5),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.20),
                            blurRadius: 18,
                            offset: Offset(4, 8),
                          )
                        ],
                      ),
                      child: GridView.builder(
                          itemCount: _user.devices[_tipo].length + 1,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                          ),
                          //SingleChildScrollView(
                          controller: _controller,
                          itemBuilder: (context, idx) {
                            if (idx == 0) {
                              return Container(
                                child: ListTile(
                                  title: Text(
                                    _titulo,
                                    textAlign: TextAlign.left,
                                    style: style,
                                  ),
                                ),
                              );
                            }
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(_routeToTvPage(
                                    _user.devices[_tipo][idx - 1],
                                    RandGradient
                                        .randGradients[idxRandGra[idx - 1]]
                                        .colors));
                              },
                              child: Container(
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.all(7.5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  //direction: Axis.vertical,
                                  children: [
                                    Text(
                                      "${_user.devices[_tipo][idx - 1]["Name"]}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            'Marca\n${_user.devices[_tipo][idx - 1]["Numbers"].length != 0 ? "Numeros" : ""}'),
                                        AnimatedContainer(
                                          width: change ? 20 : 15,
                                          height: change ? 20 : 15,
                                          duration: Duration(milliseconds: 600),
                                          curve: Curves.easeInOut,
                                          decoration: BoxDecoration(
                                            gradient:
                                                RandGradient.randGradients[
                                                    idxRandGra[idx - 1]],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            );
                          } /*[
                        Container(
                          child: ListTile(
                            title: Text(
                              _titulo,
                              textAlign: TextAlign.left,
                              style: style,
                            ),
                          ),
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    _routeToTvPage(_user.devices[_tipo][idx]));
                              },
                              child: Container(
                                width: 200,
                                height: 80,
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10,
                                  right: 10,
                                  left: 0,
                                ),
                                padding: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10,
                                  right: 10,
                                  left: 0,
                                ),
                                child: Row(
                                  //direction: Axis.horizontal,
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      iconList,
                                      alignment: Alignment.centerLeft,
                                      height: 50,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "${_user.devices[_tipo][idx]["Name"]}\nMarca\n${_user.devices[_tipo][idx]["Numbers"].length != 0 ? "Numeros" : "Nel"}",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],*/
                          ),
                    ),
                  ),
                ),
              ),
              //),
              /*ListView.builder(
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
              ),*/
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
      /*bottomNavigationBar: PreferredSize(
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
      ),*/
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

/*class ListViewDevices extends StatelessWidget {
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
}*/
