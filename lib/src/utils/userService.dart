import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:integradora/src/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

//const String URL = '192.168.1.136:3000';

const String URL = '192.168.1.106:3000';

Future<String> signin(String idToken) async {
  //final userremo = await SharedPreferences.getInstance();

  final res = await http.post(
    Uri.http(URL, '/inte/signinGoogle'),
    body: jsonEncode(<String, String>{
      'idToken': idToken,
    }),
  );

  if (res.statusCode == 200) {
    //Map<String, dynamic> userid = jsonDecode(res.body);
    //userremo.setString('user_remo', userid['id']);
    Map data = jsonDecode(res.body);
    return data['id'];
  } else
    throw Exception('Error al obtener id del Usuario');
}

Future<Usuario> getData() async {
  final user = await SharedPreferences.getInstance();
  final id = user.getString('user_remo');

  final response = await http.get(Uri.http(URL, '/inte/user/$id'));

  if (response.statusCode == 200) {
    return Usuario.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Fallo al cargar los datos del Usuario');
  }
}

Future<dynamic> newDevice(String dev, String type) async {
  final user = await SharedPreferences.getInstance();
  final id = user.getString('user_remo');

  final response = await http.post(
    Uri.http(URL, '/inte/user/$id/newDevice/$type'),
    body: dev,
  );

  if (response.statusCode == 200)
    return jsonEncode(response.body);
  else
    throw Exception('Error al insertar datoa');
}

Future<dynamic> deleteDevice(String tipo, int i) async {
  final user = await SharedPreferences.getInstance();
  final id = user.getString('user_remo');

  final response =
      await http.delete(Uri.http(URL, '/inte/user/$id/removeDevice/$tipo/$i'));

  if (response.statusCode >= 200 && response.statusCode < 300)
    return jsonEncode(response.body);
  else
    throw Exception('Error al eliminar dispositivo');
}

Future<dynamic> scheduleCommand(dynamic data) async {
  final response = await http.post(
    Uri.http(URL, '/inte/progOn'),
    body: jsonEncode(data),
  );

  if (response.statusCode == 200)
    return response.body;
  else
    throw Exception('Fallo al programar fecha');
}

void addFav(int channel) async {
  final user = await SharedPreferences.getInstance();
  final id = user.getString('user_remo');

  final response =
      await http.put(Uri.http(URL, '/inte/user/$id/newFavorite/$channel'));

  if (response.statusCode != 200) throw Exception('Fallo al agregar canal');
}

void deleteFav(List<dynamic> favs) async {
  final user = await SharedPreferences.getInstance();
  final id = user.getString('user_remo');

  final response = await http.post(
    Uri.http(URL, '/inte/user/$id/removeFavorite'),
    body: jsonEncode(favs),
  );

  if (response.statusCode != 200) throw Exception('Error al eliminar canal');
}
