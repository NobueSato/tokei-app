import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/clock_service.dart';
import '../widgets/custom_analog_clock_widget.dart';

class AnalogClockWidget extends StatelessWidget {
  final double dateFontSize;
  const AnalogClockWidget({
    Key? key,
    required this.dateFontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDebugging = false;
    ClockService clockService =
        Provider.of<ClockService>(context, listen: false);
    double clockSize = 300.0;
    double hourHandLength = 60.0;
    double minuteHandLength = 80.0;
    double secondHandLength = 100.0;

    // Inside Center widget
    return Container(
      color: isDebugging ? Colors.green : Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevents extra spacing
        children: [
          // Analog Clock with no numbers
          CustomAnalogClockWidget(
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
            isDebugging: isDebugging,
          ),

          // Display Date
          Container(
            color: isDebugging ? Colors.yellow : Colors.transparent,
            child: clockService.isDateSelected
                ? Text(
                    clockService.date,
                    style: TextStyle(
                        fontSize: dateFontSize, fontWeight: FontWeight.w400),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
