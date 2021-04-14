import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:integradora/src/models/user.dart';
import 'package:integradora/src/pages/addDevice.dart';
import 'package:integradora/src/pages/devices.dart';
import 'package:integradora/src/utils/userService.dart';

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
  final PageController controller = PageController(initialPage: 0);
  Usuario _user;
  String _tipo;
  String _title;
  String _tagTitle;
  IntCallback _callback;

  int sensivity = 8;
  int _selectidx = 0;

  String assetName = "assets/svg/Tv.svg";

  List<String> feedback;

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

  /*Route _routeToAddPage() {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 800),
      pageBuilder: (context, animation, secondaryAnimation) =>
          NewDevicePage(tipo: _tipo),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    final TextStyle style = Theme.of(context).textTheme.title.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.normal,
        );
    return Scaffold(
      //extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
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
              child: PageView(
                controller: controller,
                physics: _selectidx == 0
                    ? NeverScrollableScrollPhysics()
                    : PageScrollPhysics(parent: BouncingScrollPhysics()),
                onPageChanged: (page) {
                  setState(() => {_selectidx = page});
                },
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Row(
                          children: [
                            Text(
                              "Tv",
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () => {
                                setState(() => {
                                      _tipo = 'Tv',
                                      feedback = [
                                        'Presiona el boton de Encendido',
                                        'Presiona el boton de subir volumen +',
                                        'Presiona el boton de bajar volumen -',
                                        'Presiona el boton de cambiar canal +',
                                        'Presiona el boton de cambiar canal -'
                                      ]
                                    }),
                                controller.animateToPage(
                                  1,
                                  duration: Duration(milliseconds: 600),
                                  curve: Curves.ease,
                                )
                              },
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  SvgPicture.asset('assets/svg/Plus.svg',
                                      height: 20),
                                  SizedBox(width: 8),
                                  Text(
                                      '${AppLocalizations.of(context).labelAdd} Tv'),
                                ],
                              ),
                            ),
                          ],
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
                            itemCount: _user.devices['Tv'].length,
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
                                key: Key(_user.devices['Tv'][idx]["Name"]),
                                onDismissed: (direction) {
                                  setState(() {
                                    _callback(_user.devices['Tv'].length);
                                    _user.devices['Tv'].removeAt(idx);
                                    // *****************************
                                    //  PETICION PARA ELIMINAR AQUI
                                    // *****************************
                                    deleteDevice('Tv', idx);
                                  });
                                },
                                background: Container(
                                  color: Color.fromRGBO(255, 0, 0, 0.15),
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 80,
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        assetName,
                                        width: 60,
                                        alignment: Alignment.centerLeft,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                          '${_user.devices['Tv'][idx]["Name"]}',
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
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context).titleMedia,
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () => {
                                setState(() => {
                                      _tipo = 'Media',
                                      feedback = [
                                        'Presiona el boton de Encendido',
                                        'Presiona el boton de subir volumen +',
                                        'Presiona el boton de bajar volumen -',
                                        'Presiona el boton de reproduccion',
                                        'Presiona el boton de detener',
                                        'Presiona el boton de adelantar >',
                                        'Presiona el boton de retrasar <',
                                        'Presiona el boton de ejectar'
                                      ]
                                    }),
                                controller.animateToPage(
                                  1,
                                  duration: Duration(milliseconds: 600),
                                  curve: Curves.ease,
                                )
                              },
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  SvgPicture.asset('assets/svg/Plus.svg',
                                      height: 20),
                                  SizedBox(width: 8),
                                  Text(
                                      '${AppLocalizations.of(context).labelAdd} Media'),
                                ],
                              ),
                            ),
                          ],
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
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svg/media-play.svg',
                                        width: 60,
                                        alignment: Alignment.centerLeft,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                          '${_user.devices['Media'][idx]["Name"]}',
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
                  NewDevicePage(
                    tipo: _tipo,
                    feedback: feedback,
                    callback: (dev) => setState(
                      () => {
                        _user.devices[_tipo].add(dev),
                        _callback(_user.devices[_tipo].length)
                      },
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
