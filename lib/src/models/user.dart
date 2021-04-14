class Usuario {
  dynamic devices;
  final List<dynamic> favorites;

  Usuario({this.devices, this.favorites});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      devices: json['devices'],
      favorites: json['favorites'],
    );
  }
}
