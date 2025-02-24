import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tokei_app/main.dart';
import 'package:tokei_app/screens/calendar_screen.dart';
import '../widgets/flip_clock_widget.dart'; // Import FlipClockWidget
import '../widgets/custom_button.dart'; // Import CustomButton
import '../widgets/global_button_overlay.dart'; // Import GlobalButtonOverlay
import '../widgets/flip_clock_theme.dart'; // Import ClockTheme if necessary
import '../services/clock_service.dart';

class FlipWidget extends StatelessWidget {
  final Widget child;

  FlipWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: 0.5,
            child: child,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 2.0),
        ),
        ClipRect(
          child: Align(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.5,
            child: child,
          ),
        ),
      ],
    );
  }
}

class FlipScreen extends StatelessWidget {
  const FlipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clockService = Provider.of<ClockService>(context);
    // Define or retrieve the theme here
    final ClockTheme clockTheme = ClockTheme(
      name: 'My Clock Theme', // Add a name for the theme
      backgroundColor: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD3D5E0), Color(0xFFD7D9E5)],
          stops: [0.045, 0.949],
          transform:
              GradientRotation(11 * 3.14159 / 180), // Apply 11-degree rotation
        ),
      ), // Add a background color
      secondaryBackgroundColor:
          Colors.white, // Add a secondary background color
      textColor: Colors.black, // Add a text color
      secondaryTextColor: Colors.white70, // Add a secondary text color
      borderColor: Colors.black, // Add a border color
      hourHandColor: Colors.red, // Add hour hand color
      minuteHandColor: Colors.green, // Add minute hand color
    );

    return Scaffold(
        backgroundColor:
            Colors.transparent, // Set to transparent so the gradient shows
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
              // Centered FlipClockWidget
              OrientationBuilder(builder: (context, orientation) {
                // You can adjust the layout based on the orientation
                return Center(
                    child: orientation == Orientation.landscape
                        ? FlipClockWidget(
                            theme: clockTheme, // Pass the theme
                          )
                        : Text('Flip Portrait'));
              }),
              // Global Button Overlay
              GlobalButtonOverlay(
                buttons: [
                  CustomButton(
                    text: 'CALENDAR',
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const CalendarScreen(),
                          transitionDuration:
                              Duration(seconds: 0), // No transition
                        ),
                      );
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
                      clockService.toggleTimeFormat();
                    },
                    isSelected: clockService.is12hSelected,
                  ),
                  CustomButton(
                    text: '24H',
                    onPressed: () {
                      clockService.toggleTimeFormat();
                    },
                    isSelected: !clockService.is12hSelected,
                  ),
                  CustomButton(
                    text: '',
                    onPressed: () {},
                    isSelected: false,
                  ),
                  CustomButton(
                    text: 'DATE',
                    onPressed: () {
                      clockService.toggleDate();
                    },
                    isSelected: clockService.isDateSelected,
                  ),
                  CustomButton(
                    text: 'NORMAL',
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const ClockScreen(),
                          transitionDuration:
                              Duration(seconds: 0), // No transition
                        ),
                      );
                    },
                    isSelected: true,
                  ),
                  CustomButton(
                    text: 'FLIP',
                    onPressed: () {
                      Navigator.pushNamed(context, '/flip');
                      print("flip is pressed");
                    },
                    isSelected: false,
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
