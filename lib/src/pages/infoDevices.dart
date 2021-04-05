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
          fontSize: 48,
          fontWeight: FontWeight.bold,
        );
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.delta.dy > -sensivity) print('Abajo?');
            Navigator.of(context).pop();
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 110,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0),
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
        preferredSize: Size(MediaQuery.of(context).size.width, 110),
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        child: ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              //height: MediaQuery.of(context).size.height,
              //width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0),
              ),
              child: Stack(
                children: [
                  ListView.builder(
                    itemCount: _user.devices[_tipo].length,
                    itemBuilder: (context, idx) => Dismissible(
                      key: Key(_user.devices[_tipo][idx]["Name"]),
                      onDismissed: (direction) {
                        setState(() {
                          print(_user.devices[_tipo].length);
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
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              assetName,
                              width: 60,
                              alignment: Alignment.centerLeft,
                            ),
                            //ListTile(
                            //title:
                            SizedBox(width: 10),
                            Text('${_user.devices[_tipo][idx]["Name"]}'),
                          ],
                        ),
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
