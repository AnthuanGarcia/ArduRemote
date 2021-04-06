import 'dart:ui' as ui;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:integradora/src/models/user.dart';
import 'package:integradora/src/pages/devices.dart';
import 'package:integradora/src/pages/infoDevices.dart';
import 'package:integradora/src/utils/userService.dart';

class MenuPage extends StatefulWidget {
  User _name;

  MenuPage({Key key, User name})
      : _name = name,
        super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Usuario _user;
  User _name;
  String _tipo;
  String _titulo;
  String _tagTitle;

  int sensivity = 8;

  int lastChange = 0;

  set total(int all) => setState(() => lastChange = all);

  void joda() async {
    await getData().then((value) => {
          setState(() {
            _user = value;
            _tipo = 'Tv';
            _titulo = 'Dispositivos';
            _tagTitle = 'Titulo-devs';
            lastChange = _user.devices[_tipo].length;
          })
        });
  }

  @override
  void initState() {
    joda();
    _name = widget._name;
    super.initState();
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

//ProfilePage(usuario: user)
  @override
  Widget build(BuildContext context) {
    final TextStyle style = Theme.of(context).textTheme.title.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.normal,
        );

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
        child: Center(
          child: Text('Bienvenido, ${_name.displayName}'),
        ),
      ),
      body: _Menu(user: _user),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: _tagTitle,
                        child: Container(
                          width: MediaQuery.of(context).size.width * .65,
                          height: 60,
                          child: Column(
                            children: [
                              SvgPicture.asset('assets/svg/arrow-devs.svg'),
                              Text(
                                _titulo,
                                style: style,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width, 100),
      ),
    );
  }
}

class _Menu extends StatelessWidget {
  Usuario user;
  String titulo;
  String type;
  String tagType;

  _Menu({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle style = Theme.of(context).textTheme.title.copyWith(
          fontSize: 36,
          fontWeight: FontWeight.bold,
        );

    void _transition() {
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 1300),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return DevicePage(
              usuario: user,
              tipo: type,
              tagTitulo: tagType,
              titulo: titulo,
            );
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return Align(
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        ),
      );
    }

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xFFF2F5F8), Color(0xFFd0d6e0)],
            /*colors: <Color>[
              Color(0xFFD3F5CF),
              Color(0xFFA8DBFA),
              Color(0xFF635EE2)
            ],*/
          ),
        ),
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 40),
            padding:
                EdgeInsets.only(top: 20.0, bottom: 20, right: 20, left: 20),
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Hero(
                    tag: 'Background',
                    child: Container(
                      width: 250,
                      height: 210,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/tv-banner.png'),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: Hero(
                    tag: 'Degra',
                    child: Container(
                      width: 250,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              Color(0x77FFB7B2),
                              Color(0x7702FFC2),
                            ]),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: Hero(
                    tag: 'Titulo',
                    child: Card(
                      margin: EdgeInsets.all(0),
                      color: Colors.transparent,
                      shadowColor: Colors.transparent,
                      child: GestureDetector(
                        child: Container(
                          width: 250,
                          height: 150,
                          margin: EdgeInsets.only(
                            top: 170,
                            bottom: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.15),
                                blurRadius: 10,
                                offset: Offset(2, 6),
                              )
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              'Tv',
                              textAlign: TextAlign.left,
                              style: style,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 10,
                              bottom: 10,
                            ),
                            subtitle: Text(
                                'Dispositivos: ${user.devices["Tv"].length}\nFavoritos: ${user.favorites.length}'),
                            onTap: () => {
                              titulo = 'Tv',
                              type = 'Tv',
                              tagType = 'Titulo',
                              _transition()
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                /*Hero(
                tag: 'Titulo',
                child: Card(
                  child: GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.15),
                            blurRadius: 10,
                            offset: Offset(2, 6),
                          )
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          'Tv',
                          textAlign: TextAlign.left,
                          style: style,
                        ),
                        contentPadding: EdgeInsets.all(10),
                        subtitle: Text(
                            'Dispositivos: ${user.devices["Tv"].length}\nFavoritos: ${user.favorites.length}'),
                        onTap: () => {
                          titulo = 'Tv',
                          type = 'Tv',
                          tagType = 'Titulo',
                          _transition()
                        },
                      ),
                    ),
                    /*title: Text(
                      'Tv',
                      textAlign: TextAlign.left,
                      style: style,
                    ),
                    contentPadding: EdgeInsets.only(
                      left: 0,
                      bottom: 0,
                    ),*/
                  ),
                  color: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                ),
              ),
              Hero(
                tag: 'Titulo2',
                child: Card(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                          blurRadius: 10,
                          offset: Offset(2, 6),
                        )
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        'Reproductor',
                        textAlign: TextAlign.left,
                        style: style,
                      ),
                      subtitle:
                          Text('Dispositivos: ${user.devices["Tv"].length}'),
                      onTap: () => {
                        titulo = 'Reproductor',
                        // ****************************
                        type = 'Tv', //Cambia este TIPO
                        // ****************************
                        tagType = 'Titulo2',
                        _transition()
                      },
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  color: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                ),
              ),
              /*Divider(
                height: 1,
                thickness: 2.5,
                color: Colors.black,
              ),*/
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: Container(
                      padding: EdgeInsets.all(7.5),
                      child: SvgPicture.asset("assets/svg/Plus.svg"),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            blurRadius: 20,
                            offset: Offset(10, 10),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Agregar Dispositivo",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  )
                ],
              )*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
