import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../services/clock_service.dart';
import '../widgets/small_clock_widget.dart';
import '../widgets/small_analog_clock_widget.dart';
import '../widgets/small_flip_clock_widget.dart';
import '../widgets/country_picker_widget.dart';

class WorldClockScreen extends StatefulWidget {
  const WorldClockScreen({Key? key}) : super(key: key);

  @override
  _WorldClockScreenState createState() => _WorldClockScreenState();
}

class _WorldClockScreenState extends State<WorldClockScreen> {
  String selectedCountry = 'New York';
  final Map<String, String> timeZones = {
    'New York': 'America/New_York',
    'Los Angeles': 'America/Los_Angeles',
    'Chicago': 'America/Chicago',
    'Mexico City': 'America/Mexico_City',
    'Toronto': 'America/Toronto',
    'London': 'Europe/London',
    'Paris': 'Europe/Paris',
    'Berlin': 'Europe/Berlin',
    'Rome': 'Europe/Rome',
    'Madrid': 'Europe/Madrid',
    'Athens': 'Europe/Athens',
    'Moscow': 'Europe/Moscow',
    'Istanbul': 'Europe/Istanbul',
    'Cairo': 'Africa/Cairo',
    'Nairobi': 'Africa/Nairobi',
    'Dubai': 'Asia/Dubai',
    'Tehran': 'Asia/Tehran',
    'Karachi': 'Asia/Karachi',
    'New Delhi': 'Asia/Kolkata',
    'Kathmandu': 'Asia/Kathmandu',
    'Dhaka': 'Asia/Dhaka',
    'Bangkok': 'Asia/Bangkok',
    'Jakarta': 'Asia/Jakarta',
    'Beijing': 'Asia/Shanghai',
    'Hong Kong': 'Asia/Hong_Kong',
    'Taipei': 'Asia/Taipei',
    'Tokyo': 'Asia/Tokyo',
    'Seoul': 'Asia/Seoul',
    'Sydney': 'Australia/Sydney',
    'Melbourne': 'Australia/Melbourne',
    'Perth': 'Australia/Perth',
    'Auckland': 'Pacific/Auckland',
    'Honolulu': 'Pacific/Honolulu',
    'Santiago': 'America/Santiago',
    'Buenos Aires': 'America/Argentina/Buenos_Aires',
    'São Paulo': 'America/Sao_Paulo',
    'Cape Town': 'Africa/Johannesburg',
    'Lagos': 'Africa/Lagos',
    'Kiritimati': 'Pacific/Kiritimati',
  };

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  String getWorldTime(String timeZone) {
    final location = tz.getLocation(timeZone);
    final now = tz.TZDateTime.now(location);
    return DateFormat('hh:mm').format(now);
  }

  void _showCountryPicker() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return CountryPickerWidget(
          initialCountry: selectedCountry,
          timeZones: timeZones, // Pass the timeZones map
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedCountry = result['country']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDebugging = false;
    // Detect orientation
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    // Get screen width and height
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = isLandscape ? 220.0 : 80.0;
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

    return Container(
      // Background Color
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD3D5E0), Color(0xFFD7D9E5)],
          stops: [0.045, 0.949],
          transform:
              GradientRotation(11 * 3.14159 / 180), // Apply 11-degree rotation
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
                      // 2nd column: World clock
                      Container(
                        color: isDebugging ? Colors.amber : Colors.transparent,
                        width: column2Width,
                        child: GestureDetector(
                          behavior: HitTestBehavior
                              .translucent, // Prevents gestures from passing to the calendar
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: row3Height * 0.8,
                              ),
                              Container(
                                color: isDebugging
                                    ? Colors.green
                                    : Colors.transparent,
                                child: Text(
                                  getWorldTime(timeZones[selectedCountry]!),
                                  style: TextStyle(
                                    fontSize: fontSize * 0.4,
                                    height: fontSize * 0.005,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: _showCountryPicker,
                                child: Text(selectedCountry),
                              ),
                            ],
                          ),
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
                  color: isDebugging ? Colors.orange : Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getWorldTime(timeZones[selectedCountry]!),
                        style: TextStyle(
                          fontSize: fontSize * 0.8,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _showCountryPicker,
                        child: Text(selectedCountry),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
