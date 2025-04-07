import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/clock_service.dart';
import '../widgets/small_clock_widget.dart';
import '../widgets/small_analog_clock_widget.dart';
import '../widgets/small_flip_clock_widget.dart';
import '../widgets/stop_watch_widget.dart';

class StopwatchScreen extends StatelessWidget {
  const StopwatchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDebugging = true;
    // Detect orientation
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    // Get screen width and height
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = isLandscape ? 220.0 : 80.0;
    double stopwatchFontSize = isLandscape ? 55.0 : 80.0;
    double dateFontSize = isLandscape ? 20.0 : 14.0;
    double amPmFontSize = isLandscape ? 22.0 : 16.0;
    bool isAnalogSelected = context.watch<ClockService>().isAnalogSelected;
    bool isFlipSelected = context.watch<ClockService>().isFlipSelected;
    bool isClockSelected = isAnalogSelected || isFlipSelected ? false : true;

    // Calculate dynamic height and width percentages
    double row1Height = isLandscape
        ? screenHeight * 0.1013 // If landscape, height is 10.13%
        : isClockSelected || isFlipSelected
            ? screenHeight * 0.32
            : screenHeight *
                0.10; // 18% when isClockSelected is true, 10% when false
    double row2Height = isLandscape
        ? screenHeight * 0.7971
        : isClockSelected || isFlipSelected
            ? screenHeight * 0.1700
            : screenHeight *
                0.34; // 79.71% when it's landscape, 17% when it's portrait and 34% when analog
    double row3Height = isLandscape
        ? screenHeight * 0.1015
        : isClockSelected || isFlipSelected
            ? screenHeight * 0.30
            : screenHeight *
                0.028; // 10.15% when it's landscape, 24.6% when it's portrait

    double column1Width = screenWidth * 0.58; // 55.17%
    double column2Width = screenWidth * 0.34; // 44.83%
    double column3Width = screenWidth * 0.08; // 4.92%

    return Scaffold(
      body: Container(
        // Background Color
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFD3D5E0), Color(0xFFD7D9E5)],
            stops: [0.045, 0.949],
            transform: GradientRotation(
                11 * 3.14159 / 180), // Apply 11-degree rotation
          ),
        ),
        child: isLandscape
            ? Column(
                children: [
                  // Row 1
                  Container(
                    height: row1Height,
                    color: isDebugging ? Colors.amber : Colors.transparent,
                  ),
                  // Row 2
                  Container(
                    height: row2Height,
                    color: isDebugging ? Colors.blue : Colors.transparent,
                    child: Row(
                      children: [
                        // Row 2 Column 1
                        Container(
                          width: column1Width,
                          child: isAnalogSelected
                              ? SmallAnalogClockWidget(
                                  dateFontSize: dateFontSize)
                              : isFlipSelected
                                  ? SmallFlipClockWidget(
                                      dateFontSize: dateFontSize,
                                      amPmFontSize: amPmFontSize)
                                  : SmallClockWidget(
                                      fontSize: fontSize,
                                      dateFontSize: dateFontSize,
                                      amPmFontSize: amPmFontSize),
                        ),
                        // 2nd column: World clock
                        Container(
                          color:
                              isDebugging ? Colors.amber : Colors.transparent,
                          child: StopWatchWidget(
                            fontSize: stopwatchFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  // Row 1: Blank Space
                  Container(
                    height: row1Height,
                    color: isDebugging ? Colors.pink : Colors.transparent,
                  ),
                  // Row 2 Column 1: Clock(Digital, Analog, or Flip)
                  Container(
                    height: row2Height,
                    color: isDebugging ? Colors.blue : Colors.transparent,
                    child: isAnalogSelected
                        ? SmallAnalogClockWidget(dateFontSize: dateFontSize)
                        : isFlipSelected
                            ? SmallFlipClockWidget(
                                dateFontSize: dateFontSize,
                                amPmFontSize: amPmFontSize)
                            : SmallClockWidget(
                                fontSize: fontSize,
                                dateFontSize: dateFontSize,
                                amPmFontSize: amPmFontSize),
                  ),
                  // Row 3
                  Container(
                    height: row3Height,
                    color:
                        isDebugging ? Colors.amberAccent : Colors.transparent,
                    child: StopWatchWidget(
                      fontSize: stopwatchFontSize,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
