import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:integradora/src/utils/userService.dart';

class SchedulePage extends StatefulWidget {
  final dynamic _device;

  SchedulePage({
    Key key,
    dynamic device,
  })  : _device = device,
        super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  bool number;

  bool valid;
  bool feed;
  String validstr;
  Color validCol;

  dynamic device;
  DateTime validate;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Map scheduleinfo;

  @override
  void initState() {
    device = widget._device;
    number = false;
    valid = false;
    feed = false;
    super.initState();
  }

  _selectDate(BuildContext context) async {
    final DateTime pick = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
    );

    if (pick != null) setState(() => selectedDate = pick);
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay pickTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickTime != null && pickTime != selectedTime)
      setState(() => selectedTime = pickTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        child: SizedBox(width: MediaQuery.of(context).size.width, height: 75),
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
            child: Text(
              AppLocalizations.of(context).titleSche,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: 5, bottom: 10, left: 10, right: 10),
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .65,
                            child: InputDatePickerFormField(
                              firstDate: DateTime(2018),
                              lastDate: DateTime(2030),
                              initialDate: selectedDate,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: 15, bottom: 0, right: 15, left: 15),
                            child: SvgPicture.asset('assets/svg/Calendar.svg',
                                width: 30),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: () => _selectTime(context),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .65,
                            margin: EdgeInsets.only(top: 15, left: 10),
                            child: Text(
                              '${selectedTime.hour % 12 == 0 ? "12" : selectedTime.hour % 12}:${selectedTime.minute < 10 ? "0${selectedTime.minute}" : selectedTime.minute} ${selectedTime.hour >= 12 ? "P.M" : "A.M"}',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: 15,
                              bottom: 0,
                              right: 15,
                              left: 15,
                            ),
                            child: SvgPicture.asset('assets/svg/Clock.svg',
                                width: 30),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 20, bottom: 10, left: 10, right: 10),
                    child: Row(
                      //direction: Axis.horizontal,
                      children: [
                        Builder(
                          builder: (context) {
                            if (number) {
                              return Container(
                                width: MediaQuery.of(context).size.width * .35,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: _textController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    labelText:
                                        AppLocalizations.of(context).labelFav,
                                    //labelStyle: TextStyle(color: Colors.grey),
                                    focusColor: Colors.orange,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                  validator: (valid) {
                                    if (valid == null || valid.isEmpty)
                                      return AppLocalizations.of(context)
                                          .feedMsgFav;

                                    return null;
                                  },
                                ),
                              );
                            }
                            return SizedBox(width: 0, height: 0);
                          },
                        ),
                        Builder(
                          builder: (context) {
                            if (device["Numbers"].length != 0) {
                              return GestureDetector(
                                onTap: () => setState(() => number = !number),
                                child: Container(
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: number,
                                        onChanged: (change) {
                                          setState(() => number = change);
                                        },
                                      ),
                                      Text(
                                        AppLocalizations.of(context).checkChan,
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
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
          ),
          Builder(builder: (context) {
            if (valid && !feed) {
              valid = false;
              return Container(
                margin: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 30,
                  right: 20,
                ),
                child: FutureBuilder(
                  future: scheduleCommand(scheduleinfo),
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return Text(
                        validstr,
                        style: TextStyle(color: validCol, fontSize: 16),
                      );
                    else if (snapshot.hasError)
                      return Text(
                        'Algo ha salido mal :(',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      );
                    else
                      return Text(
                        'Programando fecha',
                        style: TextStyle(fontSize: 16),
                      );
                  },
                ),
              );
            } else if (valid && feed) {
              return Container(
                margin: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 30,
                  right: 20,
                ),
                child: Text(
                  validstr,
                  style: TextStyle(color: validCol, fontSize: 16),
                ),
              );
            }

            return SizedBox(width: 0, height: 0);
          }),
          Container(
            margin: EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
            child: Row(
              children: [
                Spacer(),
                InkWell(
                  onTap: () {
                    validate = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    if (DateTime.now().difference(validate).inSeconds < 0) {
                      validate = validate.subtract(Duration(hours: 1));
                      String valstr = validate.toIso8601String();

                      valstr = valstr.replaceRange(
                          valstr.length - 4, valstr.length, "MST");

                      scheduleinfo = device;
                      scheduleinfo["Date"] = valstr;

                      if (device["Numbers"].length != 0 && number)
                        scheduleinfo["Channel"] =
                            int.parse(_textController.text);
                      else
                        scheduleinfo["Channel"] = 0;

                      setState(() {
                        valid = true;
                        feed = false;
                        validstr = AppLocalizations.of(context).feedGoodSche;
                        validCol = Colors.green;
                      });
                    } else {
                      setState(() {
                        valid = true;
                        feed = true;
                        validstr = AppLocalizations.of(context).feedWrongSche;
                        validCol = Colors.red;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Text(AppLocalizations.of(context).btnSche),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
