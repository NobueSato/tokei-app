import 'package:flutter/material.dart';
import 'widgets/custom_button.dart';
import 'widgets/global_button_overlay.dart';
import 'dart:io'; // To detect the platform
import 'package:flutter/rendering.dart'; // For debug options
import 'screens/FlipScreen.dart'; // Import the FlipScreen file
import 'services/clock_service.dart'; // Import the clock service

void main() {
  //debugPaintSizeEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tokei App',
      theme: ThemeData(
        fontFamily: Platform.isIOS ? 'SFProText' : 'Inter', // Set fonts
      ),
      home: const ClockScreen(),
      routes: {
        '/flip': (context) => const FlipScreen(),
      },
    );
  }
}

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  late ClockService _clockService;

  @override
  void initState() {
    super.initState();
    _clockService = ClockService();
    _clockService.onDateVisibilityChanged = _updateDateVisibility;
  }

  void _updateDateVisibility() {
    setState(() {});
  }

  @override
  void dispose() {
    _clockService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    double fontSize = isLandscape ? 200.0 : 80.0;
    // Calculate the heights based on the percentages
    double topLayerHeight = MediaQuery.of(context).size.height * 0.2347;
    double middleLayerHeight = MediaQuery.of(context).size.height * 0.608;
    double bottomLayerHeight = MediaQuery.of(context).size.height * 0.1573;

    return Scaffold(
      body: Container(
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
        child: Stack(
          children: [
            Column(
              children: [
                // Top Layer
                Container(
                  height: topLayerHeight,
                ),
                // Middle Layer
                Container(
                  height: middleLayerHeight,
                  color: Colors.transparent, // Add a color if needed
                  alignment: Alignment.center, // Align Column content
                  child: Row(children: [
                    // Space between AM/PM and clock
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1404,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // AM Text
                          Text(
                            'AM', // Display AM based on the hour
                            style: TextStyle(
                              fontSize: fontSize * 0.1, // Adjust size if needed
                              fontWeight: FontWeight.w700,
                              color: _clockService.is24HourFormat
                                  ? Colors
                                      .transparent // Don't show AM when 24-hour format
                                  : (_clockService.amPm == 'AM'
                                      ? Colors.black // Darker color for AM
                                      : Colors.grey), // Lighter color for PM
                            ),
                          ),
                          SizedBox(
                            height:
                                fontSize * 0.05, // Keep space between AM and PM
                          ),
                          // PM Text
                          Text(
                            'PM', // Display PM based on the hour
                            style: TextStyle(
                              fontSize: fontSize * 0.1, // Adjust size if needed
                              fontWeight: FontWeight.w700,
                              color: _clockService.is24HourFormat
                                  ? Colors
                                      .transparent // Don't show PM when 24-hour format
                                  : (_clockService.amPm == 'PM'
                                      ? Colors.black // Darker color for PM
                                      : Colors.grey), // Lighter color for AM
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Time Text
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7192,
                      alignment: Alignment.center, // Align Column content
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Hours
                              Expanded(
                                child: Text(
                                  _clockService.hours,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w700,
                                    height:
                                        1.0, // Ensures text aligns to the top
                                    letterSpacing:
                                        -10, // Adjust this value for more/less spacing
                                  ),
                                  textAlign: TextAlign
                                      .center, // Center text within the Expanded widget
                                ),
                              ),
                              // :
                              Container(
                                alignment: Alignment.topCenter,
                                width: fontSize * 0.3, // Fixed width for colon
                                child: Opacity(
                                  opacity:
                                      _clockService.isColonVisible ? 1.0 : 0.0,
                                  child: Text(
                                    ':',
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      height:
                                          0.8, // Ensure colon is vertically aligned with text
                                      letterSpacing:
                                          -10, // Adjust this value for more/less spacing
                                    ),
                                    textHeightBehavior: TextHeightBehavior(
                                      applyHeightToFirstAscent:
                                          true, // Disable height for ascent
                                      applyHeightToLastDescent:
                                          false, // Apply height for descent
                                    ),
                                  ),
                                ),
                              ),
                              // Minutes
                              Expanded(
                                child: Text(
                                  _clockService.minutes,
                                  textAlign: TextAlign
                                      .center, // Center text within the Expanded widget
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w700,
                                    height: 1.0,
                                    letterSpacing:
                                        -10, // Adjust this value for more/less spacing
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment
                                  .center, // Centers content horizontally
                              child: _clockService.isDateSelected
                                  ? Text(
                                      _clockService.date,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1404,
                    ),
                  ]),
                ),
                // Bottom Layer
                Container(
                  height: bottomLayerHeight,
                ),
              ],
            ),
            // Global Button Overlay
            GlobalButtonOverlay(
              buttons: [
                CustomButton(
                  text: 'CALENDAR',
                  onPressed: () {},
                  isSelected: false,
                ),
                CustomButton(
                  text: 'WORLD CLOCK',
                  onPressed: () {},
                  isSelected: false,
                ),
                CustomButton(
                  text: 'STOPWATCH',
                  onPressed: () {},
                  isSelected: false,
                ),
                CustomButton(
                  text: 'TIMER',
                  onPressed: () {},
                  isSelected: false,
                ),
                CustomButton(
                  text: 'D',
                  onPressed: () {},
                  isSelected: false,
                ),
                CustomButton(
                  text: 'A',
                  onPressed: () {},
                  isSelected: false,
                ),
                CustomButton(
                  text: '12h',
                  onPressed: () {
                    setState(() {
                      _clockService.toggle24HourFormat();
                    });
                  },
                  isSelected: !_clockService.is24HourFormat,
                ),
                CustomButton(
                  text: '24h',
                  onPressed: () {
                    setState(() {
                      _clockService.toggle24HourFormat();
                    });
                  },
                  isSelected: _clockService.is24HourFormat,
                ),
                CustomButton(
                  text: '',
                  onPressed: () {},
                  isSelected: false,
                ),
                CustomButton(
                  text: 'Date',
                  onPressed: () {
                    setState(() {
                      _clockService.toggleDateView();
                    });
                  },
                  isSelected: _clockService.date.isNotEmpty,
                ),
                CustomButton(
                  text: 'Normal',
                  onPressed: () {},
                  isSelected: true,
                ),
                CustomButton(
                  text: 'Flip',
                  onPressed: () {
                    Navigator.pushNamed(context, '/flip');
                  },
                  isSelected: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
