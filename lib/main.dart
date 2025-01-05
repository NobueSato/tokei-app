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
        bottomNavigationBar: SizedBox(
          height: MediaQuery.of(context).size.height *
              0.2, // 20% of viewport height
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 3, // 3 columns
              mainAxisSpacing: 8.0, // Spacing between rows
              crossAxisSpacing: 8.0, // Spacing between columns
              shrinkWrap: true, // Adjusts size based on content
              physics:
                  const NeverScrollableScrollPhysics(), // Disable scrolling
              childAspectRatio: 2.0, // Aspect ratio for each child
              children: <Widget>[
                // First Row: 12h, empty, Normal
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _is24HourFormat = false; // Switch to 12-hour format
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !_is24HourFormat
                        ? const Color(0xFFEEE8B6)
                        : const Color(0xFFE5E5E5),
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12.0), // Set corner radius
                    ),
                  ),
                  child: const Text(
                    '12h',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                // Empty placeholder
                Container(),
                // Normal button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _updateTime();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE5E5E5),
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12.0), // Set corner radius
                    ),
                  ),
                  child: const Text(
                    'Normal',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                // Second Row: 24h, Date, Flip
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _is24HourFormat = true; // Switch to 24-hour format
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _is24HourFormat
                        ? const Color(0xFFEEE8B6)
                        : const Color(0xFFE5E5E5),
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12.0), // Set corner radius
                    ),
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
                      _hours =
                          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${_formatAMPM(now.hour)}";
                      _minutes = '';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE5E5E5),
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12.0), // Set corner radius
                    ),
                  ),
                  child: const Text(
                    'Date',
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
                    backgroundColor: const Color(0xFFEEEEEE),
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12.0), // Set corner radius
                    ),
                  ),
                  child: const Text(
                    'Flip',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
