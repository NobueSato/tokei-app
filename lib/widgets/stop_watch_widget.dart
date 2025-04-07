import 'dart:async';
import 'package:flutter/material.dart';

class StopWatchWidget extends StatefulWidget {
  final double fontSize;
  const StopWatchWidget({
    Key? key,
    required this.fontSize,
  }) : super(key: key);

  @override
  _StopWatchWidgetState createState() => _StopWatchWidgetState();
}

class _StopWatchWidgetState extends State<StopWatchWidget> {
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  int _milliseconds = 0; // to keep track of the milliseconds manually
  int _seconds = 0; // to keep track of the seconds manually
  int _minutes = 0; // to keep track of minutes manually
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
        Duration(milliseconds: 10), _updateTime); // Update every 10ms
  }

  // Update the time every 10ms
  void _updateTime(Timer timer) {
    if (_stopwatch.isRunning) {
      setState(() {
        _milliseconds += 1;

        // Reset milliseconds after 100ms
        if (_milliseconds == 100) {
          _milliseconds = 0;
          _seconds += 1;
        }

        // Reset seconds after 60 seconds
        if (_seconds == 60) {
          _seconds = 0;
          _minutes += 1;
        }
      });
    }
  }

  // Start the stopwatch
  void _startStopwatch() {
    setState(() {
      _isRunning = true;
    });
    _stopwatch.start();
  }

  // Stop the stopwatch
  void _stopStopwatch() {
    setState(() {
      _isRunning = false;
    });
    _stopwatch.stop();
  }

  // Reset the stopwatch
  void _resetStopwatch() {
    setState(() {
      _isRunning = false;
      _stopwatch.reset();
      _milliseconds = 0;
      _seconds = 0;
      _minutes = 0;
    });
  }

  // Format the time to MM:SS:MS
  String _formatTime() {
    String minuteStr = _minutes.toString().padLeft(2, '0');
    String secondStr = _seconds.toString().padLeft(2, '0');
    String millisecondStr =
        _milliseconds.toString().padLeft(2, '0'); // Always 2 digits

    return '$minuteStr:$secondStr:$millisecondStr';
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Stopwatch time display with separate components
          SizedBox(
            width: isLandscape ? 300 : 250,
            height: widget.fontSize * 1.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display minutes part (MM)
                Container(
                  width: widget.fontSize * 1.5, // Fixed width for minutes
                  child: Text(
                    _minutes.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Separator ':'
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Display seconds part (SS)
                Container(
                  width: widget.fontSize * 1.5, // Fixed width for seconds
                  child: Text(
                    _seconds.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Separator '.'
                Text(
                  '.',
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Display milliseconds part (MS)
                Container(
                  width: widget.fontSize * 1.5, // Fixed width for milliseconds
                  child: Text(
                    _milliseconds.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _isRunning ? _stopStopwatch : _startStopwatch,
                child: Text(_isRunning ? "Stop" : "Start"),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: _resetStopwatch,
                child: Text("Reset"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
