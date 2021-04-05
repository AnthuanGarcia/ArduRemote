import 'package:flutter/cupertino.dart';

class FavoritesPage extends StatefulWidget {
  final List<dynamic> _favs;

  FavoritesPage({Key key, List<dynamic> favs})
      : _favs = favs,
        super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritesPage> {
  List<dynamic> favs;

  @override
  void initState() {
    favs = widget._favs;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text('Hola Favs $favs');
  }
}
