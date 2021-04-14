import 'dart:ui' as ui;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:integradora/src/models/user.dart';
import 'package:integradora/src/pages/devices.dart';
import 'package:integradora/src/pages/infoDevices.dart';
import 'package:integradora/src/utils/userService.dart';

typedef void IntCallback(int val);

class MenuPage extends StatefulWidget {
  User _name;
  Usuario _data;

  MenuPage({Key key, User name, Usuario data})
      : _name = name,
        _data = data,
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

  List<Widget> menuCards;

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
    //joda();
    _name = widget._name;
    _user = widget._data;
    _tipo = 'Tv';
    _tagTitle = 'Titulo-devs';
    lastChange = _user.devices[_tipo].length;
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
    _titulo = AppLocalizations.of(context).tagDevs;
    final TextStyle style = Theme.of(context).textTheme.title.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.normal,
        );

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
        child: Center(
          child: Text(
              '${AppLocalizations.of(context).msgMenu}, ${_name.displayName}'),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                /*gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: <Color>[
                    Color(0xFFFFD8F6),
                    Color(0xFFD4D9FF),
                  ],
                  //<Color>[Color(0xFFF2F5F8), Color(0xFFd0d6e0)]
                ),*/
              ),
            ),
          ),
          ListView.builder(
            itemCount: 2,
            scrollDirection: Axis.horizontal,
            physics: PageScrollPhysics(parent: BouncingScrollPhysics()),
            itemBuilder: (context, idx) {
              menuCards = [
                _Menu(
                  user: _user,
                  titulo: 'Tv',
                  tagtitulo: 'tv-title',
                  type: 'Tv',
                  banner: 'tv-back',
                  degra: 'tv-degra',
                  assetName: 'assets/Tv.png',
                  colors: [
                    Color(0xEEFF84E3),
                    Color(0xEEC2C9FF),
                  ],
                ),
                _Menu(
                  user: _user,
                  titulo: AppLocalizations.of(context).titleMedia,
                  tagtitulo: 'media-title',
                  type: 'Media', // CAMBIAR
                  banner: 'media-back',
                  degra: 'media-degra',
                  assetName: 'assets/media-play.png',
                  colors: [
                    Color(0x66B2FFFA),
                    Color(0x662602FF),
                  ],
                )
              ];
              return menuCards[idx];
            },
          )
        ],
      ),
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
  String tagtitulo;
  String banner;
  String degra;
  String assetName;
  List<Color> colors;

  _Menu(
      {Key key,
      @required this.user,
      @required this.titulo,
      @required this.type,
      @required this.tagtitulo,
      @required this.banner,
      @required this.degra,
      @required this.assetName,
      @required this.colors})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle style = Theme.of(context).textTheme.title.copyWith(
          fontSize: 32,
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
              tagTitulo: tagtitulo,
              titulo: titulo,
              tagBack: banner,
              tagDegra: degra,
              assetName: assetName,
              colors: colors,
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
      child: GestureDetector(
        onTap: () => _transition(),
        child: Container(
          margin: EdgeInsets.only(top: 40, right: 30, left: 30),
          padding: EdgeInsets.all(25),
          child: Stack(
            children: <Widget>[
              /*Positioned(
                child: Hero(
                  tag: banner,
                  child: Container(
                    width: 250,
                    height: 210,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(assetName),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
              ),*/
              /*Positioned(
                child: Hero(
                  tag: degra,
                  child: Container(
                    width: 250,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: colors),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
              ),*/
              Positioned(
                child: Hero(
                  tag: tagtitulo,
                  child: Card(
                    margin: EdgeInsets.all(0),
                    color: Colors.transparent,
                    shadowColor: Colors.transparent,
                    child: Container(
                      width: 250,
                      height: 230,
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * .02,
                        bottom: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.20),
                            blurRadius: 12,
                            offset: Offset(4, 7),
                          )
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 100,
                                  child: ListTile(
                                    title: Text(
                                      titulo,
                                      textAlign: TextAlign.left,
                                      style: style,
                                    ),
                                    contentPadding: EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      top: 0,
                                      bottom: 0,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: 80,
                                  height: 20,
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: colors),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Text(
                                      '${AppLocalizations.of(context).tagDevs}: ${user.devices[type].length}\n${AppLocalizations.of(context).tagFav}: ${user.favorites.length}'),
                                  Spacer(),
                                  Image.asset(assetName, height: 30)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
    );
  }
}
