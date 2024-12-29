import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tokei App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ClockScreen(),
    );
  }
}

class ClockScreen extends StatefulWidget {
  ClockScreen({Key? key}) : super(key: key); // Add the named key parameter

  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  String _timeFormat = '12h'; // Default 12-hour format
  String _clockText = '';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (_timeFormat == '12h') {
          _clockText = _get12HourTime();
        } else if (_timeFormat == '24h') {
          _clockText = _get24HourTime();
        } else if (_timeFormat == 'Date') {
          _clockText = _getDate();
        } else if (_timeFormat == 'Flip') {
          _clockText = _getFlipClockTime();
        } else {
          _clockText = _get12HourTime();
        }
      });
    });
  }

  String _get12HourTime() {
    final now = DateTime.now();
    final hour = now.hour % 12;
    final minute = now.minute;
    final second = now.second;
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')} $ampm';
  }

  String _get24HourTime() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;
    final second = now.second;
    return '$hour:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
  }

  String _getDate() {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;
    final weekday = now.weekday;
    final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}-${daysOfWeek[weekday - 1]}';
  }

  String _getFlipClockTime() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE), // Background color
      appBar: AppBar(
        title: Text('Tokei App'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display clock in the middle of the screen
          Text(
            _clockText,
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          // Row with buttons at the bottom
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _timeFormat = '12h';
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    side: MaterialStateProperty.all(BorderSide(color: Colors.black)),
                  ),
                  child: Text(
                    '12h',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _timeFormat = '24h';
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    side: MaterialStateProperty.all(BorderSide(color: Colors.black)),
                  ),
                  child: Text(
                    '24h',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _timeFormat = 'Date';
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    side: MaterialStateProperty.all(BorderSide(color: Colors.black)),
                  ),
                  child: Text(
                    'Date',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _timeFormat = 'Normal';
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    side: MaterialStateProperty.all(BorderSide(color: Colors.black)),
                  ),
                  child: Text(
                    'Normal',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _timeFormat = 'Flip';
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    side: MaterialStateProperty.all(BorderSide(color: Colors.black)),
                  ),
                  child: Text(
                    'Flip',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
