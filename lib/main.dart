import 'package:flutter/material.dart';
import 'widgets/custom_button.dart';
import 'widgets/global_button_overlay.dart';
import 'package:universal_io/io.dart'; // To detect the platform
//import 'package:flutter/rendering.dart'; // For debug options
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'widgets/clock_widget.dart'; // Import the ClockWidget file
import 'screens/calendar_screen.dart'; // Import the CalendarScreen file
import 'screens/flip_screen.dart'; // Import the FlipScreen file

void main() {
  //debugPaintSizeEnabled = true;
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
        '/main': (context) => const ClockScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/flip': (context) => const FlipScreen(),
      },
    );
  }
}

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  bool _is12hSelected = true; // Default: Show 12h format
  bool _isDateSelected = false; // Default: Hide Date

  @override
  void initState() {
    super.initState();
    // Ensure the screen stays awake
    WakelockPlus.enable();
  }

  // void _updateDateVisibility() {
  //   setState(() {});
  // }

  @override
  void dispose() {
    WakelockPlus.disable(); // Disable the wakelock when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double fontSize = isLandscape ? 200.0 : 80.0;
    double dateFontSize = isLandscape ? 20.0 : 14.0;

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
            ClockWidget(
              fontSize: fontSize,
              dateFontSize: dateFontSize,
              isDateSelected: _isDateSelected,
              is12hSelected: _is12hSelected,
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
                        _is12hSelected = !_is12hSelected;
                      });
                    },
                    isSelected: _is12hSelected),
                CustomButton(
                  text: '24H',
                  onPressed: () {
                    setState(() {
                      print(
                          '24H button pressed before the value changed: $_is12hSelected');
                      _is12hSelected = !_is12hSelected;
                      print(
                          '24H button pressed after the value changed: $_is12hSelected');
                    });
                  },
                  isSelected: !_is12hSelected,
                ),
                CustomButton(
                  text: '',
                  onPressed: () {},
                  isSelected: true,
                ),
                CustomButton(
                  text: 'DATE',
                  onPressed: () {
                    setState(() {
                      _isDateSelected = !_isDateSelected;
                    });
                  },
                  isSelected: _isDateSelected,
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
