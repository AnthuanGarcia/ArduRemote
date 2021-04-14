import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:integradora/src/utils/userService.dart';

class FavoritesPage extends StatefulWidget {
  final List<dynamic> _favs;

  FavoritesPage({Key key, List<dynamic> favs})
      : _favs = favs,
        super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritesPage> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  List<dynamic> favs;

  @override
  void initState() {
    favs = widget._favs;
    super.initState();
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
      body: Container(
        margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).titleFav,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _textController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).labelFav,
                  //labelStyle: TextStyle(color: Colors.grey),
                  focusColor: Colors.orange,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                validator: (valid) {
                  if (valid == null || valid.isEmpty)
                    return AppLocalizations.of(context).feedMsgFav;

                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 30,
                left: 30,
                right: 30,
                bottom: 5,
              ),
              child: Text(
                '${AppLocalizations.of(context).tagChannel}:',
                style: TextStyle(fontSize: 10),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .80,
              height: MediaQuery.of(context).size.width * .50,
              child: Container(
                margin: EdgeInsets.only(
                  top: 5,
                  left: 50,
                  right: 50,
                  bottom: 0,
                ),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: favs.length,
                  itemBuilder: (context, idx) => Dismissible(
                    key: Key(favs[idx].toString()),
                    onDismissed: (direction) {
                      setState(() {
                        favs.removeAt(idx);
                        deleteFav(favs);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        '${favs[idx]}',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Spacer(),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        int channel = int.parse(_textController.text);
                        favs.add(channel);
                        addFav(channel);
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Text(AppLocalizations.of(context).btnFav),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
