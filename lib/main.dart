import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // Correct import for debugPaintSizeEnabled
import 'dart:async';

void main() {
  //debugPaintSizeEnabled = true; // Enable debug layout painting
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tokei App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial',
      ),
      home: const ClockScreen(),
    );
  }
}

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  late Timer _timer;
  String _hours = '';
  String _minutes = '';
  bool _is24HourFormat = true; // Default to 24-hour format
  bool _isColonVisible = true; // Track if the colon is visible or not

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
      _isColonVisible = !_isColonVisible; // Toggle the colon visibility
      // Check format: 24-hour or 12-hour
      if (_is24HourFormat) {
        _hours = now.hour.toString().padLeft(2, '0');
        _minutes = now.minute.toString().padLeft(2, '0');
      } else {
        _hours = _formatTime(now.hour);
        _minutes = now.minute.toString().padLeft(2, '0');
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hour Text
                Text(
                  _hours,
                  style: const TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Blinking colon with fixed width and adjusted alignment
                Container(
                  width: 30, // Fixed width for the colon space
                  alignment: Alignment
                      .center, // Ensure the colon is centered vertically
                  child: Text(
                    _isColonVisible
                        ? ':'
                        : '', // Colon blinks by toggling visibility
                    style: TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      color: _isColonVisible
                          ? Colors.black
                          : Colors
                              .transparent, // Only color the colon when visible
                    ),
                  ),
                ),
                // Minute Text
                Text(
                  _minutes,
                  style: const TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
