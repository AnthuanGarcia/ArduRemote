import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:integradora/src/models/user.dart';
import 'package:integradora/src/pages/devices.dart';

typedef void IntCallback(int val);

class CardInfo extends StatefulWidget {
  CardInfo(
      {Key key,
      Usuario usuario,
      String tipo,
      String titulo,
      String tagTitulo,
      Function callback})
      : _user = usuario,
        _tipo = tipo,
        _title = titulo,
        _tagTitle = tagTitulo,
        _callback = callback,
        super(key: key);

  final Usuario _user;
  final String _tipo;
  final String _title;
  final String _tagTitle;
  final IntCallback _callback;

  @override
  _CardInfoState createState() => _CardInfoState();
}

class _CardInfoState extends State<CardInfo>
    with SingleTickerProviderStateMixin {
  Usuario _user;
  String _tipo;
  String _title;
  String _tagTitle;
  IntCallback _callback;

  int sensivity = 8;

  String assetName = "assets/svg/Tv.svg";

  var _dragoff;

  @override
  void initState() {
    _user = widget._user;
    _tipo = widget._tipo;
    _title = widget._title;
    _tagTitle = widget._tagTitle;
    _callback = widget._callback;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle style = Theme.of(context).textTheme.title.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.normal,
        );
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.delta.dy > -sensivity) Navigator.of(context).pop();
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: 15,
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                child: Container(
                  //padding: EdgeInsets.only(
                  //    left: 20.0, right: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Hero(
                    tag: _tagTitle,
                    child: Text(
                      _title,
                      style: style,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width, 90),
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        child: ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Text(
                      "Tv",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    height: 0,
                    thickness: 1,
                    indent: 5,
                    endIndent: 5,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: Container(
                      child: ListView.separated(
                        itemCount: _user.devices[_tipo].length,
                        physics: BouncingScrollPhysics(),
                        separatorBuilder: (context, idx) => Divider(
                          height: 0,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.black,
                        ),
                        itemBuilder: (context, idx) {
                          return Dismissible(
                            key: Key(_user.devices[_tipo][idx]["Name"]),
                            onDismissed: (direction) {
                              setState(() {
                                _callback(_user.devices[_tipo].length);
                                _user.devices[_tipo].removeAt(idx);
                                // *****************************
                                //  PETICION PARA ELIMINAR AQUI
                                // *****************************
                                // ->
                              });
                            },
                            background: Container(
                              color: Color.fromRGBO(255, 0, 0, 0.15),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 80,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    assetName,
                                    width: 60,
                                    alignment: Alignment.centerLeft,
                                  ),
                                  SizedBox(width: 10),
                                  Text('${_user.devices[_tipo][idx]["Name"]}',
                                      style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Text(
                      "Media",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    height: 0,
                    thickness: 1,
                    indent: 5,
                    endIndent: 5,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: Container(
                      child: ListView.separated(
                        itemCount: _user.devices['Media'].length,
                        physics: BouncingScrollPhysics(),
                        separatorBuilder: (context, idx) => Divider(
                          height: 0,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.black,
                        ),
                        itemBuilder: (context, idx) {
                          return Dismissible(
                            key: Key(_user.devices['Media'][idx]["Name"]),
                            onDismissed: (direction) {
                              setState(() {
                                _callback(_user.devices['Media'].length);
                                _user.devices['Media'].removeAt(idx);
                                // *****************************
                                //  PETICION PARA ELIMINAR AQUI
                                // *****************************
                                // ->
                              });
                            },
                            background: Container(
                              color: Color.fromRGBO(255, 0, 0, 0.15),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 80,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/media-play.svg',
                                    width: 60,
                                    alignment: Alignment.centerLeft,
                                  ),
                                  SizedBox(width: 10),
                                  Text('${_user.devices['Media'][idx]["Name"]}',
                                      style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
