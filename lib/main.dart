import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tokei App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ClockScreen(),
    );
  }
}

class ClockScreen extends StatefulWidget {
  const ClockScreen({Key? key}) : super(key: key);

  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  late Timer _timer;
  String _time = '';
  bool _is24HourFormat = true; // Default to 24-hour format

  @override
  void initState() {
    super.initState();
    _updateTime(); // Update immediately on start
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTime(); // Update every second
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    setState(() {
      // Check format: 24-hour or 12-hour
      if (_is24HourFormat) {
        _time = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
      } else {
        _time = "${_formatTime(now.hour)}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')} ${_formatAMPM(now.hour)}";
      }
    });
  }

  String _formatTime(int hour) {
    return hour % 12 == 0 ? '12' : (hour % 12).toString().padLeft(2, '0');
  }

  String _formatAMPM(int hour) {
    return hour >= 12 ? 'PM' : 'AM';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tokei App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              _time, // Display the current time
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 8.0, // Space between buttons
          runSpacing: 8.0, // Space between rows of buttons
          alignment: WrapAlignment.center, // Center the buttons
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _is24HourFormat = false; // Switch to 12-hour format
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: !_is24HourFormat ? const Color(0xFFEEE8B6) : const Color(0xFFE5E5E5),
                side: const BorderSide(color: Colors.black),
              ),
              child: const Text(
                '12h',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _is24HourFormat = true; // Switch to 24-hour format
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _is24HourFormat ? const Color(0xFFEEE8B6) : const Color(0xFFE5E5E5),
                side: const BorderSide(color: Colors.black),
              ),
              child: const Text(
                '24h',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  final now = DateTime.now();
                  _time = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${_formatAMPM(now.hour)}";
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE5E5E5),
                side: const BorderSide(color: Colors.black),
              ),
              child: const Text(
                'Date',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Reset to default normal time view
                  _updateTime();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE5E5E5),
                side: const BorderSide(color: Colors.black),
              ),
              child: const Text(
                'Normal',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Flip clock logic can be added here
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE5E5E5),
                side: const BorderSide(color: Colors.black),
              ),
              child: const Text(
                'Flip',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
