import 'package:flutter/material.dart';
import 'widgets/custom_button.dart';
import 'widgets/global_button_overlay.dart';
import 'package:universal_io/io.dart'; // To detect the platform
import 'package:flutter/rendering.dart'; // For debug options
import 'screens/CalendarScreen.dart'; // Import the CalendarScreen file
import 'screens/FlipScreen.dart'; // Import the FlipScreen file
import 'services/clock_service.dart'; // Import the clock service
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  //debugPaintSizeEnabled = true;
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Hide both status bar and navigation bar (using setSystemUIMode)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      title: 'Tokei App',
      theme: ThemeData(
        fontFamily: Platform.isIOS ? 'SFProText' : 'Inter', // Set fonts
      ),
      home: const ClockScreen(),
      routes: {
        '/calendar': (context) => const CalendarScreen(),
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
    double dateFontSize = isLandscape ? 20.0 : 14.0;
    // Calculate the heights based on the percentages
    double topLayerHeight =
        MediaQuery.of(context).size.height * 0.2347; // 23.47%
    double middleLayerHeight =
        MediaQuery.of(context).size.height * 0.608; // 60.8%
    double ampmContainerWidth = MediaQuery.of(context).size.width * 0.1404;
    double timeContainerWidth = MediaQuery.of(context).size.width * 0.7192;
    double bottomLayerHeight =
        MediaQuery.of(context).size.height * 0.1573; // 15.73%

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
                SizedBox(
                  height: middleLayerHeight,
                  child: Row(children: [
                    // Space between AM/PM and clock
                    SizedBox(
                      width: ampmContainerWidth,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // AM Text
                          Text(
                            'AM', // Display AM based on the hour
                            style: TextStyle(
                              fontSize: fontSize * 0.1, // Adjust size if needed
                              fontWeight: FontWeight.w500,
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
                                fontSize * 0.2, // Keep space between AM and PM
                          ),
                          // PM Text
                          Text(
                            'PM', // Display PM based on the hour
                            style: TextStyle(
                              fontSize: fontSize * 0.1, // Adjust size if needed
                              fontWeight: FontWeight.w500,
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
                    Expanded(
                      child: SizedBox(
                        width: timeContainerWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: isLandscape
                                  ? MediaQuery.of(context).size.height * 0.54
                                  : null,
                              child: FittedBox(
                                fit: BoxFit
                                    .contain, // Ensure text scales down uniformly
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, // Centers content horizontally
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, // Ensures vertical alignment
                                  children: [
                                    // Hours
                                    FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        _clockService.hours,
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.w700,
                                          height:
                                              1.0, // Ensures text aligns to the top
                                          letterSpacing:
                                              -7, // Adjust this value for more/less spacing
                                        ),
                                        textAlign: TextAlign
                                            .end, // Center text within the FittedBox
                                      ),
                                    ),
                                    // Colon
                                    Container(
                                      width: fontSize *
                                          0.34, // Fixed width for colon
                                      alignment:
                                          Alignment.center, // Centers colon
                                      child: Opacity(
                                        opacity: _clockService.isColonVisible
                                            ? 1.0
                                            : 0.0,
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Text(
                                            ':',
                                            style: TextStyle(
                                              fontSize: fontSize,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              height:
                                                  0.8, // Ensure colon is vertically aligned with text
                                            ),
                                            textHeightBehavior:
                                                TextHeightBehavior(
                                              applyHeightToFirstAscent:
                                                  true, // Disable height for ascent
                                              applyHeightToLastDescent:
                                                  false, // Apply height for descent
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Minutes
                                    FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        _clockService.minutes,
                                        textAlign: TextAlign
                                            .start, // Center text within the FittedBox
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.w700,
                                          height: 1.0,
                                          letterSpacing:
                                              -7, // Adjust this value for more/less spacing
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: isLandscape
                                  ? MediaQuery.of(context).size.height * 0.0567
                                  : dateFontSize,
                              alignment: Alignment
                                  .center, // Centers content horizontally
                              child: _clockService.isDateSelected
                                  ? FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        _clockService.date,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: dateFontSize,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          ],
                        ),
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/calendar');
                  },
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
                  text: '12H',
                  onPressed: () {
                    setState(() {
                      _clockService.toggle24HourFormat();
                    });
                  },
                  isSelected: !_clockService.is24HourFormat,
                ),
                CustomButton(
                  text: '24H',
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
                  text: 'DATE',
                  onPressed: () {
                    setState(() {
                      _clockService.toggleDateView();
                    });
                  },
                  isSelected: _clockService.date.isNotEmpty,
                ),
                CustomButton(
                  text: 'NORMAL',
                  onPressed: () {},
                  isSelected: true,
                ),
                CustomButton(
                  text: 'FLIP',
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
