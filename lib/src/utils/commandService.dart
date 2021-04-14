import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'package:integradora/src/utils/userService.dart';
//const String _URL = '192.168.1.136:3000';
//const String _URL = '192.168.1.106:3000';

class DeviceInfo {
  int capture;
  int protocol;
  int addr;
  int command;

  DeviceInfo({Key key, this.capture, this.command, this.protocol, this.addr});
}

void sendCommand(dynamic info) async {
  await http.post(
    Uri.http(URL, '/inte/sendCommand'),
    body: info,
  );
}

void favCommand(dynamic info) async {
  await http.post(
    Uri.http(URL, '/inte/favorite'),
    body: info,
  );
}

Future<dynamic> newCommand(DeviceInfo action) async {
  final response = await http.post(
    Uri.http(URL, '/inte/newCommand'),
    body: jsonEncode(<String, int>{
      'capture': action.capture,
      'protocol': action.protocol,
      'addr': action.addr,
      'command': action.command
    }),
  );

  if (response.statusCode == 200)
    return jsonDecode(response.body);
  else {
    throw Exception('Fallo al capturar comando');
  }
}
