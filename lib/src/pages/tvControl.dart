import 'dart:convert';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:integradora/src/utils/commandService.dart';

class TvControlPage extends StatefulWidget {
  final dynamic _tv;
  final List<dynamic> _favs;

  TvControlPage({Key key, dynamic tv, List<dynamic> favs})
      : _tv = tv,
        _favs = favs,
        super(key: key);

  @override
  _TvControlPageState createState() => _TvControlPageState();
}

class _TvControlPageState extends State<TvControlPage> {
  final PageController controller = PageController(initialPage: 1);
  dynamic _tv;
  List<dynamic> _favs;

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
        //color: Color(0xFFFEFFFF),
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFFFEFFFF),
              Color(0xFFE2EAF3),
              //Color(0xFFd6e2ee)
            ]),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.10),
            blurRadius: 15,
            offset: Offset(8, 8),
          )
        ],
      ),
      child: Image.asset(assetName),
    );
  }

  Container _roundedLargeBtn(
      String assetName, double altura, int commPlus, int commMin) {
    return Container(
      width: 78,
      height: 187,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        //color: Color(0xFFFEFFFF),
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFFFEFFFF),
              Color(0xFFE2EAF3),
              //Color(0xFFd6e2ee)
            ]),
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
              child: Image.asset('assets/Plus.png'),
            ),
          ),
          Container(
            width: 40,
            height: altura,
            padding: EdgeInsets.all(0),
            child: Image.asset(assetName),
          ),
          GestureDetector(
            onTap: () {
              sendCommand(genRequest(commMin));
            },
            child: Container(
                width: 35,
                height: 35,
                padding: EdgeInsets.all(2),
                child: Image.asset('assets/Minus.png')),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _tv = widget._tv;
    _favs = widget._favs;
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
      appBar: PreferredSize(
        child: SizedBox(width: MediaQuery.of(context).size.width, height: 75),
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
      ),
      body: Center(
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width / 7,
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
                  child: _roundedBtn('assets/symOn.png', 10)),
              Row(
                children: [
                  _roundedLargeBtn(
                      'assets/Vol.png', 50, _tv["VolUp"], _tv["VolDown"]),
                  Spacer(),
                  _roundedLargeBtn(
                      'assets/CH.png', 40, _tv["ChaUp"], _tv["ChaDown"])
                ],
              ),
              GestureDetector(
                  onTap: () {
                    dynamic info = _tv;
                    int channel = _favs.removeAt(0);

                    _favs.add(channel);
                    info['channel'] = channel;

                    favCommand(jsonEncode(info));
                  },
                  child: _roundedBtn('assets/Fav.png', 14))
            ],
          ),
        ),
      ),
    );
  }
}
