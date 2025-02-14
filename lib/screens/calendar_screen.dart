import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../services/clock_service.dart';
import '../widgets/small_clock_widget.dart';
import '../widgets/custom_button.dart'; // Import your CustomButton file here
import '../widgets/global_button_overlay.dart';

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
    // Detect orientation
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    // Get screen width and height
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final clockService = Provider.of<ClockService>(context);

    // Calculate dynamic height and width percentages
    double row1Height =
        isLandscape ? screenHeight * 0.1013 : screenHeight * 0.1958; // 10.13%
    double row2Height = isLandscape ? screenHeight * 0.7946 : 0.1379; // 79.46%
    double row3Height = isLandscape ? screenHeight * 0.1015 : 0.246; // 10.15%
    double row4Height = screenHeight * 0.3669; // 36.69%
    double row5Height = screenHeight * 0.1945; // 19.45%

    double column1Width = screenWidth * 0.5517; // 55.17%
    double column2Width = screenWidth * 0.40; // 44.83%
    double column3Width = screenWidth * 0.048; // 4.92%

    double fontSize = isLandscape ? 100.0 : 80.0;
    double amPmFontSize = isLandscape ? 22.0 : 16.0;
    double dateFontSize = 14.0;
    bool _isDateSelected = false;
    bool _is12hSelected = true;
    bool _is24hSelected = false;

    return Scaffold(
      body: Stack(children: [
        OrientationBuilder(
          builder: (context, orientation) {
            // Layout for landscape mode
            return Container(
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
              child: orientation == Orientation.landscape
                  ? Column(
                      children: [
                        // 1st row
                        Container(
                          height: row1Height,
                          color: Colors.blue,
                        ),
                        Container(
                          height: row2Height,
                          child: Row(
                            children: [
                              // 1st column
                              Container(
                                width: column1Width,
                                color: Colors.green,
                                child: SmallClockWidget(
                                    fontSize: fontSize,
                                    dateFontSize: dateFontSize,
                                    amPmFontSize: amPmFontSize),
                              ),
                              // 2nd column: Smaller Calendar
                              Container(
                                width: column2Width,
                                color: Colors.orange,
                                child: GestureDetector(
                                  behavior: HitTestBehavior
                                      .translucent, // Prevents gestures from passing to the calendar
                                  child: Container(
                                    width: column2Width * 0.9,
                                    color: Colors.yellow,
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        TableCalendar(
                                          firstDay: DateTime.utc(2000, 1, 1),
                                          lastDay: DateTime.utc(2100, 12, 31),
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
                                color: Colors.indigoAccent,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: row3Height,
                          color: Colors.brown,
                        ),
                      ],
                    )
                  :
                  // Layout for portrait
                  Column(
                      children: [
                        // 1st row
                        Container(
                          height: row1Height,
                          color: Colors.blue,
                          child: Center(child: Text('First Row')),
                        ),
                        // 2nd row
                        Container(
                            height: screenHeight * 0.18,
                            color: Colors.amberAccent,
                            child: SmallClockWidget(
                                fontSize: fontSize,
                                dateFontSize: dateFontSize,
                                amPmFontSize: amPmFontSize)),
                        // 3rd row
                        Container(
                          height: row1Height * 0.3,
                          color: Colors.green,
                        ),

                        // 4th row: Calendar
                        Container(
                          height: 350, // 36.69% of parent height
                          color: Colors.orange,
                          child: GestureDetector(
                            behavior: HitTestBehavior
                                .translucent, // Prevents gestures from passing to the calendar
                            child: Container(
                              height: 300,
                              width: 330,
                              color: Colors.yellow,
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  TableCalendar(
                                    firstDay: DateTime.utc(2000, 1, 1),
                                    lastDay: DateTime.utc(2100, 12, 31),
                                    currentDay: null,
                                    focusedDay:
                                        _focusedDay, // This ensures the calendar focuses on the correct day
                                    calendarFormat: _calendarFormat,
                                    selectedDayPredicate: (day) =>
                                        _selectedDay != null &&
                                        isSameDay(day, _selectedDay),
                                    onFormatChanged: (format) {
                                      if (_calendarFormat != format) {
                                        setState(() {
                                          _calendarFormat = format;
                                        });
                                      }
                                    },
                                    onPageChanged: (focusedDay) {
                                      _focusedDay = focusedDay;
                                    },
                                    calendarStyle: CalendarStyle(
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // 5th row
                        Container(
                          height: 169, // 19.45% of parent height
                          color: Colors.purple,
                        ),
                      ],
                    ),
            );
          },
        ),
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
                Provider.of<ClockService>(context, listen: false)
                    .toggleTimeFormat();
              },
              isSelected: Provider.of<ClockService>(context).is12hSelected,
            ),
            CustomButton(
              text: '24H',
              onPressed: () {
                Provider.of<ClockService>(context, listen: false)
                    .toggleTimeFormat();
              },
              isSelected: !Provider.of<ClockService>(context).is12hSelected,
            ),
            CustomButton(
              text: '',
              onPressed: () {},
              isSelected: false,
            ),
            CustomButton(
              text: 'DATE',
              onPressed: () {
                Provider.of<ClockService>(context, listen: false).toggleDate();
              },
              isSelected: Provider.of<ClockService>(context, listen: false)
                  .isDateSelected,
            ),
            CustomButton(
              text: 'NORMAL',
              onPressed: () {
                Navigator.pushNamed(context, '/main');
              },
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
      ]),
    );
  }
}
