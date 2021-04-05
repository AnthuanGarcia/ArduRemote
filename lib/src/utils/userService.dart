import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:integradora/src/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _URL = '192.168.1.136:3000';

void signin(String idToken) async {
  final userremo = await SharedPreferences.getInstance();

  final res = await http.post(
    Uri.http(_URL, '/inte/sigin'),
    body: jsonEncode(<String, String>{
      'idToken': idToken,
    }),
  );

  if (res.statusCode == 200) {
    Map<String, dynamic> userid = jsonDecode(res.body);
    userremo.setString('user_remo', userid['id']);
  } else
    throw Exception('Error al obtener id del Usuario');
}

Future<Usuario> getData() async {
  final user = await SharedPreferences.getInstance();
  final id = user.getString('user_remo');

  final response = await http.get(Uri.http(_URL, '/inte/user/$id'));

  if (response.statusCode == 200) {
    return Usuario.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Fallo al cargar los datos del Usuario');
  }
}
