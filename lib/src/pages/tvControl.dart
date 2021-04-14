import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:integradora/src/utils/commandService.dart';

class TvControlPage extends StatefulWidget {
  final dynamic _tv;
  final List<dynamic> _favs;
  final List<Color> _deco;

  TvControlPage({Key key, dynamic tv, List<dynamic> favs, List<Color> deco})
      : _tv = tv,
        _favs = favs,
        _deco = deco,
        super(key: key);

  @override
  _TvControlPageState createState() => _TvControlPageState();
}

class _TvControlPageState extends State<TvControlPage> {
  final PageController controller = PageController(initialPage: 1);
  dynamic _tv;
  List<dynamic> _favs;
  List<Color> _colors;

  double posX;
  double posY;

  String genRequest(int comm) {
    DeviceInfo req = DeviceInfo(
      capture: 0,
      protocol: _tv["Protocol"],
      addr: _tv["Addres"],
      command: comm,
    );

    return jsonEncode(<String, dynamic>{
      'capture': req.capture,
      'protocol': req.protocol,
      'addr': req.addr,
      'command': req.command
    });
  }

  Container _roundedBtn(String assetName, double pad) {
    return Container(
      width: 78,
      height: 78,
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: Color(0xFFFEFFFF),
        /*gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFFFEFFFF),
              Color(0xFFE2EAF3),
              //Color(0xFFd6e2ee)
            ]),*/
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.10),
            blurRadius: 15,
            offset: Offset(8, 8),
          )
        ],
      ),
      child: SvgPicture.asset(assetName),
    );
  }

  Container _roundedLargeBtn(
      String assetName, double altura, int commPlus, int commMin) {
    return Container(
      width: 78,
      height: 187,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFFEFFFF),
        /*gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFFFEFFFF),
              Color(0xFFE2EAF3),
              //Color(0xFFd6e2ee)
            ]),*/
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.10),
            blurRadius: 15,
            offset: Offset(8, 8),
          )
        ],
      ),
      child: Wrap(
        direction: Axis.vertical,
        alignment: WrapAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              sendCommand(genRequest(commPlus));
            },
            child: Container(
              width: 35,
              height: 35,
              padding: EdgeInsets.all(2),
              child: SvgPicture.asset('assets/svg/Plus.svg'),
            ),
          ),
          Container(
            width: 40,
            height: altura,
            padding: EdgeInsets.all(0),
            child: SvgPicture.asset(assetName),
          ),
          GestureDetector(
            onTap: () {
              sendCommand(genRequest(commMin));
            },
            child: Container(
              width: 35,
              height: 35,
              padding: EdgeInsets.all(2),
              child: SvgPicture.asset('assets/svg/Minus.svg'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _tv = widget._tv;
    _favs = widget._favs;
    _colors = widget._deco;

    posX = Random().nextDouble();
    posY = Random().nextDouble();

    BackButtonInterceptor.add(interceptor);
    super.initState();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(interceptor);
    super.dispose();
  }

  bool interceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Navigator.pop(context);
    return true;
  }

  //_roundedBtn('assets/svg/symOn.svg')
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        child: SizedBox(width: MediaQuery.of(context).size.width, height: 75),
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
      ),
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height / 2 * posX,
              left: MediaQuery.of(context).size.width / 2 * posY,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  color: _colors[0].withOpacity(0.4),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 2 * posY,
              left: MediaQuery.of(context).size.width / 2 * .10,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  color: _colors[1].withOpacity(0.4),
                ),
              ),
            ),
            Positioned(
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(color: Colors.transparent),
                  ),
                ),
              ),
            ),
            /*Image.asset(
              'assets/back-prron.png',
              width: double.infinity,
              height: double.infinity,
            ),*/
            Container(
              color: Colors.transparent,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.35,
                bottom: 15,
                left: 35,
                right: 35,
              ),
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        sendCommand(genRequest(_tv["OnOff"]));
                      },
                      child: _roundedBtn('assets/svg/symOn.svg', 10)),
                  Row(
                    children: [
                      _roundedLargeBtn('assets/svg/Vol.svg', 50, _tv["VolUp"],
                          _tv["VolDown"]),
                      Spacer(),
                      _roundedLargeBtn(
                          'assets/svg/CH.svg', 40, _tv["ChaUp"], _tv["ChaDown"])
                    ],
                  ),
                  Builder(
                    builder: (context) {
                      if (_tv["Numbers"].length != 0) {
                        return GestureDetector(
                          onTap: () {
                            dynamic info = _tv;
                            int channel = _favs.removeAt(0);

                            _favs.add(channel);
                            info['Channel'] = channel;

                            favCommand(jsonEncode(info));
                          },
                          child: _roundedBtn('assets/svg/Fav.svg', 14),
                        );
                      }

                      return SizedBox(width: 0, height: 0);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
