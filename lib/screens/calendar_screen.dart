import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/clock_widget.dart';
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
    double topLayerHeight = isLandscape
        ? MediaQuery.of(context).size.height * 0.1013
        : 150; // 23.46%
    double bottomLayerHeight =
        isLandscape ? MediaQuery.of(context).size.height * 0.104 : 100; // 5%
    bool _isDateSelected = false;
    bool _is12hSelected = true;

    return Scaffold(
      body: Stack(children: [
        Container(
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
          child: Column(
            children: [
              Container(
                height: topLayerHeight,
              ),
              Expanded(
                child: Row(
                  children: [
                    // Far left space
                    Flexible(
                      flex: 10, // 4.5% of width
                      child: Container(
                        height: 100,
                      ),
                    ),
                    // Left Side: Smaller Clock
                    Expanded(
                      flex: 42,
                      child: ClockWidget(
                        fontSize: 50,
                        dateFontSize: 10,
                        isDateSelected: _isDateSelected,
                        is12hSelected: _is12hSelected,
                      ),
                    ),
                    // Right Side: Smaller Calendar
                    Expanded(
                      flex: 40,
                      child: GestureDetector(
                        behavior: HitTestBehavior
                            .translucent, // Prevents gestures from passing to the calendar
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
                    // Fourth space
                    Flexible(
                      flex: 8, // Same flex as first element
                      child: Container(
                        height: 100,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: bottomLayerHeight,
              ),
            ],
          ),
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
              onPressed: () {},
              isSelected: false,
            ),
            CustomButton(
              text: '24H',
              onPressed: () {},
              isSelected: false,
            ),
            CustomButton(
              text: '',
              onPressed: () {},
              isSelected: false,
            ),
            CustomButton(
              text: 'DATE',
              onPressed: () {},
              isSelected: false,
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
