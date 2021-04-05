import 'package:flutter/cupertino.dart';

class SchedulePage extends StatefulWidget {
  final List<dynamic> _numbers;
  final int _onCommand;

  SchedulePage({Key key, List<dynamic> numbers, int onCommand})
      : _numbers = numbers,
        _onCommand = onCommand,
        super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<dynamic> numbers;
  int onCommand;

  @override
  void initState() {
    numbers = widget._numbers;
    onCommand = widget._onCommand;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text('Hola num $numbers, $onCommand');
  }
}
