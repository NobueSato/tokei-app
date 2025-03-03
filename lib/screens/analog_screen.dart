import 'package:flutter/material.dart';
import 'package:analog_clock/analog_clock.dart';

class AnalogClockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analog Clock'),
      ),
      body: Center(
        child: AnalogClock(
          decoration: BoxDecoration(
            border:
                Border.all(width: 2.0, color: Colors.black), // Use Colors.black
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          width: 150.0,
          isLive: true,
          hourHandColor: Colors.black,
          minuteHandColor: Colors.black,
          showSecondHand: false,
          numberColor: Colors.black87,
          showNumbers: true,
          showAllNumbers: false,
          textScaleFactor: 1.4,
          showTicks: false,
          showDigitalClock: false,
          datetime: DateTime(2019, 1, 1, 9, 12,
              15), // Fixed time (you can update to DateTime.now() for live time)
        ),
      ),
    );
  }
}
