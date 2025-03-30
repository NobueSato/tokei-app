import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/clock_service.dart';
import '../widgets/custom_analog_clock_widget.dart';

class AnalogClockWidget extends StatelessWidget {
  const AnalogClockWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ClockService clockService =
        Provider.of<ClockService>(context, listen: false);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double clockSize = clockService.isSmallScreen ? 250.0 : 300.0;
    double hourHandLength = clockService.isSmallScreen ? 40.0 : 60.0;
    double minuteHandLength = clockService.isSmallScreen ? 60.0 : 80.0;
    double secondHandLength = clockService.isSmallScreen ? 70.0 : 100.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center, // Ensure alignment
      children: [
        // Analog Clock with no numbers
        Expanded(
          child: CustomAnalogClockWidget(
            clockSize: clockSize,
            hourHandLength: hourHandLength,
            minuteHandLength: minuteHandLength,
            secondHandLength: secondHandLength,
            hourHandColor: Colors.black,
            minuteHandColor: Colors.black,
            secondHandColor: Colors.black,
            tickColor: Colors.grey,
            numberColor: Colors.black,
            tickMode: TickMode.twoBetweenNumbers,
            showTime: false,
            showDate: false,
          ),
        ),

        const SizedBox(height: 50), // Space between clock and date

        // Display Date
        clockService.isDateSelected
            ? Text(
                clockService.date,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
