import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:integradora/src/utils/commandService.dart';
import 'package:integradora/src/utils/userService.dart';

typedef void DevCallback(dynamic val);

class NewDevicePage extends StatefulWidget {
  final String _tipo;
  final List<String> _feedback;
  final DevCallback _callback;

  NewDevicePage(
      {Key key,
      @required String tipo,
      @required List<String> feedback,
      @required Function callback})
      : _tipo = tipo,
        _feedback = feedback,
        _callback = callback,
        super(key: key);

  @override
  _NewDeviceState createState() => _NewDeviceState();
}

class _NewDeviceState extends State<NewDevicePage> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  String tipo;
  int sensivity = 8;
  String actualfeed;
  List<String> feedback;

  int idx = 0;
  bool pass = false;
  bool nextComm = true;
  bool captured = false;

  DeviceInfo act = DeviceInfo(capture: 1, addr: 0, protocol: 0, command: 0);
  dynamic command;
  Map<String, dynamic> device = Map<String, dynamic>();
  DevCallback addDev;

  List<String> commandsTv = [
    'OnOff',
    'VolUp',
    'VolDown',
    'ChaUp',
    'ChaDown',
  ];

  List<String> assets = [
    'assets/svg/add/symOn.svg',
    'assets/svg/add/chmin.svg',
    'assets/svg/add/chplus.svg',
    'assets/svg/add/volldo.svg',
    'assets/svg/add/volup.svg'
  ];

  List<bool> success;
  List<bool> oversized;

  //List<Widget> inte;

  @override
  void initState() {
    tipo = widget._tipo;
    feedback = widget._feedback;
    addDev = widget._callback;
    success = List.filled(commandsTv.length, false);
    oversized = List.filled(commandsTv.length, false);
    // TODO: implement initState
    super.initState();
  }

  Widget addDevForm() {
    return Column(children: [
      Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: TextFormField(
                controller: _textController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).inputName,
                    //labelStyle: TextStyle(color: Colors.grey),
                    focusColor: Colors.orange,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    )),
                validator: (valid) {
                  if (valid == null || valid.isEmpty)
                    return AppLocalizations.of(context).feedMsgAdd;

                  return null;
                },
              ),
            )
          ],
        ),
      ),
      SizedBox(height: 15),
      InkWell(
        highlightColor: Colors.white,
        splashColor: Colors.white,
        onTap: () {
          if (_formKey.currentState.validate()) {
            setState(() => pass = true);
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.30),
                blurRadius: 16,
                offset: Offset(3, 6),
              )
            ],
          ),
          child: Text(
            AppLocalizations.of(context).btnForm,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      )
    ]);
  }

  Widget successCommand() {
    return Container(
      child: Row(
        children: [
          Text('$actualfeed'),
          SvgPicture.asset('assets/svg/check.svg', height: 30)
        ],
      ),
    );
  }

  newComm() async {
    return await newCommand(act);
  }

  captureCommands(i) async {
    setState(() => {nextComm = false, oversized[i] = true});
    var comma = await newComm();

    device['Protocol'] = comma['info']['protocol'];
    device['Addres'] = comma['info']['addr'];
    device[commandsTv[i]] = comma['info']['command'];
    setState(
      () => {
        actualfeed = feedback[i],
        nextComm = true,
        success[i] = true,
        oversized[i] = false,
        if (success.every((element) => element))
          {
            captured = true,
            device['Numbers'] = [],
            addDev(device),
          }
        //inte.add(successCommand()),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 10, left: 15, right: 15),
          child: Text(
            '${AppLocalizations.of(context).labelAdd} $tipo',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Builder(
          builder: (context) {
            if (!pass)
              return addDevForm();
            else {
              device["Name"] = _textController.text;
              return Center(
                child: Column(
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      children: [
                        for (int i = 0; i < feedback.length; i++)
                          AbsorbPointer(
                            absorbing: nextComm ? false : true,
                            child: GestureDetector(
                              onTap: () {
                                captureCommands(i);
                              },
                              child: AnimatedContainer(
                                width: oversized[i] ? 100 : 78,
                                height: oversized[i] ? 100 : 78,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(10),
                                duration: Duration(milliseconds: 800),
                                curve: Curves.easeInOut,
                                decoration: BoxDecoration(
                                  color: success[i]
                                      ? Color(0xFF9AF39E)
                                      : Color(0xFFFEFFFF),
                                  borderRadius: BorderRadius.circular(70),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.10),
                                      blurRadius: 15,
                                      offset: Offset(8, 8),
                                    )
                                  ],
                                ),
                                child: SvgPicture.asset(
                                  assets[i],
                                  color: success[i]
                                      ? Color(0xFFFEFFFF)
                                      : Color(0xFF000000),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                    Builder(
                      builder: (BuildContext context) {
                        if (captured)
                          return FutureBuilder(
                            future: newDevice(jsonEncode(device), tipo),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                nextComm = false;
                                captured = false;
                                return SvgPicture.asset('assets/svg/check.svg',
                                    width: 78);
                              } else if (snapshot.hasError)
                                return Text('Algo salio mal :(');
                              else
                                return Text(
                                    '${AppLocalizations.of(context).capturingDev}...');
                            },
                          );
                        else
                          return SizedBox(width: 10);
                      },
                    )
                  ],
                ),
              );
            }
          },
        )

        /*FutureBuilder(
            future: newCommand(act),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {}
            })*/
      ],
    );
  }
}
