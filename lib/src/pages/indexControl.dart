import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:integradora/src/pages/funcionalities/scheduleDate.dart';
import 'package:integradora/src/pages/funcionalities/favorites.dart';
import 'package:integradora/src/pages/tvControl.dart';
import 'package:integradora/src/widgets/navBottomBar.dart';

class IndexControlPage extends StatefulWidget {
  final dynamic _tv;
  final List<dynamic> _favs;
  final List<Color> _colors;

  IndexControlPage(
      {Key key, dynamic tv, List<dynamic> favs, List<Color> colors})
      : _tv = tv,
        _favs = favs,
        _colors = colors,
        super(key: key);

  @override
  _IndexControlPageState createState() => _IndexControlPageState();
}

class _IndexControlPageState extends State<IndexControlPage> {
  final PageController controller = PageController(initialPage: 1);
  dynamic _tv;
  List<dynamic> _favs;
  List<Color> _colors;

  int _selectedIndex = 1;

  @override
  void initState() {
    _tv = widget._tv;
    _favs = widget._favs;
    _colors = widget._colors;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(30.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child:
                    SvgPicture.asset('assets/svg/arrow-back.svg', height: 22),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * .25),
              Text(
                '${_tv["Name"]}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width, 75),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(color: Color(0xFFFEFFFF)
              /*gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: <Color>[Color(0xFFFEFFFF), Color(0xFFbcd7f2)],
            ),*/
              ),
          child: PageView(
            controller: controller,
            children: [
              FavoritesPage(favs: _favs),
              TvControlPage(tv: _tv, favs: _favs, deco: _colors),
              SchedulePage(device: _tv),
            ],
            onPageChanged: (page) {
              setState(() => _selectedIndex = page);
            },
          ),
        ),
      ),
      bottomNavigationBar: NavBottomBar(
        currentIdx: _selectedIndex,
        onChange: (index) {
          controller.animateToPage(
            index,
            duration: Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        },
        children: [
          CustomIcon(nameass: 'assets/svg/Fav.svg'),
          CustomIcon(nameass: 'assets/svg/symOn.svg'),
          CustomIcon(nameass: 'assets/svg/Calendar.svg'),
        ],
      ),
    );
  }
}
