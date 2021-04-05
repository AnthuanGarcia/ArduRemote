import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:integradora/src/models/user.dart';
import 'package:integradora/src/pages/devices.dart';
import 'package:integradora/src/utils/userService.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Usuario _user;

  @override
  void initState() async {
    await getData().then((value) => {
          setState(() {
            _user = value;
          })
        });
    super.initState();
  }

//ProfilePage(usuario: user)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
        child: Center(
          child: Text('Seleccione un Dispositivo'),
        ),
      ),
      body: _Menu(user: _user),
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xFFFEFFFF), Color(0xFFbcd7f2)],
            /*colors: <Color>[
              Color(0xFFD3F5CF),
              Color(0xFFA8DBFA),
              Color(0xFF635EE2)
            ],*/
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 180),
          padding: EdgeInsets.only(top: 20.0, bottom: 20, right: 20, left: 20),
          child: Column(
            children: <Widget>[
              Hero(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
