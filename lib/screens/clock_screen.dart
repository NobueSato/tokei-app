import 'package:flutter/material.dart';
import '../widgets/clock_widget.dart';

class ClockScreen extends StatelessWidget {
  const ClockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double fontSize = isLandscape ? 220.0 : 80.0;
    double dateFontSize = isLandscape ? 20.0 : 14.0;
    double amPmFontSize = isLandscape ? 22.0 : 16.0;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD3D5E0), Color(0xFFD7D9E5)],
        ),
      ),
      child: Center(
        child: ClockWidget(
            fontSize: fontSize,
            dateFontSize: dateFontSize,
            amPmFontSize: amPmFontSize),
      ),
    );
  }
}
