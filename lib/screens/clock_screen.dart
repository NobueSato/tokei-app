import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/clock_widget.dart';
import '../widgets/analog_clock_widget.dart';
import '../widgets/flip_clock_widget.dart';
import '../services/clock_service.dart';

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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD3D5E0), Color(0xFFD7D9E5)],
        ),
      ),
      child: Center(
        child: Selector<ClockService, (bool, bool)>(
          selector: (_, clockService) => (
            clockService.isAnalogSelected,
            clockService.isFlipSelected,
          ),
          builder: (_, selectedClockMode, __) {
            bool isAnalogSelected = selectedClockMode.$1;
            bool isFlipSelected = selectedClockMode.$2;

            if (isAnalogSelected) {
              return const AnalogClockWidget();
            } else if (isFlipSelected) {
              return const FlipClockWidget();
            } else {
              return ClockWidget(
                fontSize: fontSize,
                dateFontSize: dateFontSize,
                amPmFontSize: amPmFontSize,
              );
            }
          },
        ),
      ),
    );
  }
}
