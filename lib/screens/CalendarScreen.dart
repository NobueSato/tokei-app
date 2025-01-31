import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/custom_button.dart'; // Import your CustomButton file here
import '../widgets/global_button_overlay.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Detect orientation
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
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
                height: isLandscape
                    ? MediaQuery.of(context).size.height * 0.1013
                    : 100,
              ),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      flex: 10, // 4.5% of width
                      child: Container(
                        height: 100,
                      ),
                    ),
                    // Left Side: Smaller Clock
                    Expanded(
                      flex: 40,
                      child: Container(
                        child: Center(
                          child: SizedBox(
                            height: 150, // Resize the clock widget
                            width: 150,
                            child: Text("Tokei"),
                          ),
                        ),
                      ),
                    ),
                    // Right Side: Smaller Calendar
                    Expanded(
                      flex: 40,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.82,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            TableCalendar(
                              firstDay: DateTime.utc(2000, 1, 1),
                              lastDay: DateTime.utc(2100, 12, 31),
                              focusedDay: DateTime.now(),
                              calendarStyle: CalendarStyle(
                                todayDecoration: BoxDecoration(
                                  color: Color(0xFFF5F5F5),
                                  shape: BoxShape.circle,
                                ),
                                todayTextStyle: TextStyle(
                                  color: Colors
                                      .black, // Set today's date text color to black
                                ),
                                selectedDecoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
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
                              onDaySelected: (selectedDay, focusedDay) {
                                print('Selected day: $selectedDay');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Fourth element
                    Flexible(
                      flex: 10, // Same flex as first element
                      child: Container(
                        height: 100,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: isLandscape
                    ? MediaQuery.of(context).size.height * 0.05
                    : 100,
              ),
            ],
          ),
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
                Navigator.pop(context);
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
