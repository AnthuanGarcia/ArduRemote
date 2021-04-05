import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

const String _URL = '192.168.1.136:3000';

class DeviceInfo {
  int capture;
  int protocol;
  int addr;
  int command;

  DeviceInfo({Key key, this.capture, this.command, this.protocol, this.addr});
}

void sendCommand(dynamic info) async {
  await http.post(
    Uri.http(_URL, '/inte/sendCommand'),
    body: info,
  );
}

void favCommand(dynamic info) async {
  await http.post(
    Uri.http(_URL, '/inte/favorite'),
    body: info,
  );
}
