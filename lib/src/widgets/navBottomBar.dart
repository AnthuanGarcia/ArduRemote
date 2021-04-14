import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavBottomBar extends StatefulWidget {
  final List<CustomIcon> _children;
  final Function(int) _onChange;
  final int _currentIdx;

  NavBottomBar(
      {Key key,
      List<CustomIcon> children,
      Function(int) onChange,
      int currentIdx})
      : _children = children,
        _onChange = onChange,
        _currentIdx = currentIdx,
        super(key: key);

  @override
  _NavBottomBarState createState() => _NavBottomBarState();
}

class _NavBottomBarState extends State<NavBottomBar> {
  void _changeIndex(int idx) {
    if (widget._onChange != null) {
      widget._onChange(idx);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: EdgeInsets.only(left: 15, right: 15),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widget._children.map(
          (item) {
            var icon = item;
            int idx = widget._children.indexOf(item);

            return GestureDetector(
              onTap: () {
                _changeIndex(idx);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                width: 50,
                padding: EdgeInsets.only(
                  top: widget._currentIdx == idx ? 0 : 20,
                ),
                //margin: EdgeInsets.only(top: 10, bottom: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.transparent),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SvgPicture.asset(
                      icon.nameass,
                      width: 32,
                    ),
                  ],
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

class CustomIcon {
  final String nameass;

  CustomIcon({@required this.nameass});
}
