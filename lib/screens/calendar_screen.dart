import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../services/clock_service.dart';
import '../widgets/small_clock_widget.dart';
import '../widgets/small_analog_clock_widget.dart';
import '../widgets/small_flip_clock_widget.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    bool isDebugging = false;
    // Detect orientation
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    // Get screen width and height
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = isLandscape ? 100.0 : 80.0;
    double dateFontSize = isLandscape ? 20.0 : 14.0;
    double amPmFontSize = isLandscape ? 22.0 : 16.0;
    bool isAnalogSelected = context.watch<ClockService>().isAnalogSelected;
    bool isFlipSelected = context.watch<ClockService>().isFlipSelected;
    bool isClockSelected = isAnalogSelected || isFlipSelected ? false : true;

    // Calculate dynamic height and width percentages
    double row1Height = isLandscape
        ? screenHeight * 0.1013 // If landscape, height is 10.13%
        : isClockSelected || isFlipSelected
            ? screenHeight * 0.1800
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
            ? screenHeight * 0.0900
            : screenHeight *
                0.028; // 10.15% when it's landscape, 24.6% when it's portraitt
    double row4Height = isLandscape
        ? screenHeight * 0.3669
        : isClockSelected || isFlipSelected
            ? screenHeight * 0.3900
            : screenHeight * 0.37; // 36.69%
    double row5Height = isLandscape
        ? screenHeight * 0.1945
        : isClockSelected || isFlipSelected
            ? screenHeight * 0.1700 // 17%
            : screenHeight * 0.1620;

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
                      // 1st column
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
                      // 2nd column: Calendar
                      Container(
                        width: column2Width,
                        child: GestureDetector(
                          behavior: HitTestBehavior
                              .translucent, // Prevents gestures from passing to the calendar
                          child: Container(
                            width: column2Width * 0.9,
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                TableCalendar(
                                  firstDay: DateTime.utc(2000, 1, 1),
                                  lastDay: DateTime.utc(2100, 12, 31),
                                  rowHeight: 45,
                                  currentDay: null,
                                  focusedDay:
                                      _focusedDay, // This ensures the calendar focuses on the correct day
                                  calendarFormat: _calendarFormat,
                                  selectedDayPredicate: (day) =>
                                      _selectedDay != null &&
                                      isSameDay(day, _selectedDay),
                                  onFormatChanged: (format) {
                                    if (_calendarFormat != format) {
                                      // Call `setState()` when updating calendar format
                                      setState(() {
                                        _calendarFormat = format;
                                      });
                                    }
                                  },
                                  onPageChanged: (focusedDay) {
                                    // No need to call `setState()` here
                                    _focusedDay = focusedDay;
                                  },
                                  calendarStyle: CalendarStyle(
                                    // Adjust row spacing (default is 52.0)
                                    todayDecoration: BoxDecoration(
                                      color: Colors
                                          .transparent, // Remove background color
                                      shape: BoxShape.circle,
                                    ),
                                    todayTextStyle: TextStyle(
                                        color: Color(
                                            0xFF2F2F2F) // Set today's date text color to black
                                        ),
                                    selectedDecoration: BoxDecoration(
                                      color: Color(0xFFF5F5F5),
                                      shape: BoxShape.circle,
                                    ),
                                    selectedTextStyle: TextStyle(
                                      color: Color(0xFF2F2F2F),
                                    ),
                                    outsideDecoration: BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    weekendTextStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  headerStyle: HeaderStyle(
                                    formatButtonVisible: false,
                                    titleCentered: true,
                                    titleTextFormatter: (date, locale) =>
                                        '${date.year}.${date.month.toString().padLeft(2, '0')}', // Format YYYY.MM
                                    titleTextStyle: TextStyle(
                                      fontSize: 20, // Change font size
                                      fontWeight:
                                          FontWeight.w700, // Change font weight
                                      color: Color(
                                          0xFF2F2F2F), // Optional: Change color
                                    ),
                                  ),
                                  daysOfWeekStyle: DaysOfWeekStyle(
                                    weekendStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    dowTextFormatter: (date, locale) {
                                      const weekdays = [
                                        'S',
                                        'M',
                                        'T',
                                        'W',
                                        'T',
                                        'F',
                                        'S'
                                      ]; // Sunday to Saturday
                                      return weekdays[date.weekday %
                                          7]; // Adjust for Sunday-based index
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // 3rd column
                      Container(
                        width: column3Width,
                        color: isDebugging ? Colors.brown : Colors.transparent,
                      ),
                    ],
                  ),
                ),
                // Row 3
                Container(
                  height: row3Height,
                  color: isDebugging ? Colors.cyanAccent : Colors.transparent,
                ),
              ],
            )
          :
          // Layout for portrait
          Column(
              children: [
                // Row 1
                Container(
                  height: row1Height,
                  color: isDebugging ? Colors.pink : Colors.transparent,
                ),
                // Row 2
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
                                amPmFontSize: amPmFontSize)),
                // 3rd row
                Container(
                  height: row3Height,
                  color: isDebugging ? Colors.green : Colors.transparent,
                ),

                // 4th row: Calendar
                Container(
                  height: row4Height,
                  color: isDebugging ? Colors.cyan : Colors.transparent,
                  child: GestureDetector(
                    behavior: HitTestBehavior
                        .translucent, // Prevents gestures from passing to the calendar
                    child: Container(
                      height: 300,
                      width: 330,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          TableCalendar(
                            firstDay: DateTime.utc(2000, 1, 1),
                            lastDay: DateTime.utc(2100, 12, 31),
                            rowHeight: 45,
                            currentDay: null,
                            focusedDay:
                                _focusedDay, // This ensures the calendar focuses on the correct day
                            calendarFormat: _calendarFormat,
                            selectedDayPredicate: (day) =>
                                _selectedDay != null &&
                                isSameDay(day, _selectedDay),
                            onFormatChanged: (format) {
                              if (_calendarFormat != format) {
                                // Call `setState()` when updating calendar format
                                setState(() {
                                  _calendarFormat = format;
                                });
                              }
                            },
                            onPageChanged: (focusedDay) {
                              // No need to call `setState()` here
                              _focusedDay = focusedDay;
                            },
                            calendarStyle: CalendarStyle(
                              // Adjust row spacing (default is 52.0)
                              todayDecoration: BoxDecoration(
                                color: Colors
                                    .transparent, // Remove background color
                                shape: BoxShape.circle,
                              ),
                              todayTextStyle: TextStyle(
                                  color: Color(
                                      0xFF2F2F2F) // Set today's date text color to black
                                  ),
                              selectedDecoration: BoxDecoration(
                                color: Color(0xFFF5F5F5),
                                shape: BoxShape.circle,
                              ),
                              selectedTextStyle: TextStyle(
                                color: Color(0xFF2F2F2F),
                              ),
                              outsideDecoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              weekendTextStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              titleTextFormatter: (date, locale) =>
                                  '${date.year}.${date.month.toString().padLeft(2, '0')}', // Format YYYY.MM
                              titleTextStyle: TextStyle(
                                fontSize: 20, // Change font size
                                fontWeight:
                                    FontWeight.w700, // Change font weight
                                color:
                                    Color(0xFF2F2F2F), // Optional: Change color
                              ),
                            ),
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekendStyle: TextStyle(
                                color: Colors.white,
                              ),
                              dowTextFormatter: (date, locale) {
                                const weekdays = [
                                  'S',
                                  'M',
                                  'T',
                                  'W',
                                  'T',
                                  'F',
                                  'S'
                                ]; // Sunday to Saturday
                                return weekdays[date.weekday %
                                    7]; // Adjust for Sunday-based index
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 5th row
                Container(
                  height: row5Height,
                  color: isDebugging ? Colors.red : Colors.transparent,
                ),
              ],
            ),
    );
  }
}
