import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/clock_service.dart';

class ClockWidget extends StatelessWidget {
  final double fontSize;
  final double dateFontSize;
  final double amPmFontSize;
  final bool is12hSelected = true;
  final bool is24hSelected = false;
  final bool isDateSelected = false;

  const ClockWidget({
    Key? key,
    required this.fontSize,
    required this.dateFontSize,
    required this.amPmFontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clockService = Provider.of<ClockService>(context);
    bool isDebugging = false;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    // Get the screen height using MediaQuery
    double screenHeight = MediaQuery.of(context).size.height;

    int row1height = isLandscape
        ? 2346 // 23.46% when it's landscape
        : 4310; // 43.10% when it's portrait
    int row2height = isLandscape
        ? 5334 // 5334% when it's landscape
        : 1380; // 13.8% when it's portrait
    int row3Height = isLandscape
        ? 1546 // 15.46% when it's landscape
        : 4310; // 43.1% when it's portrait
    int row2Column1width = isLandscape
        ? 0789 // 7.89% when it's landscape
        : 0250; // 2.500% when it's portrait
    int row2Column2width = isLandscape
        ? 0615 // 6.15% when it's landscape
        : 1346; // 13.46% when it's portrait
    int row2Column3width = isLandscape
        ? 7426 // 74.26% when it's landscape
        : 6700; // 57.07% when it's portrait
    int row2Column4width = isLandscape
        ? 1170 // 11.70% when it's landscape
        : 1604; // 7.28% when it's portrait
    int dateHeight = isLandscape
        ? 0774 // 12.67% when it's landscape
        : 0260; // 2.46% when it's portrait
    double amPmHeight = isLandscape
        ? screenHeight * 0.2453 // 24.53 when it's landscape
        : screenHeight * 0.0738; // 7.38% when it's portrait

    return Column(
      children: [
        // Row 1: Space above the clock
        Expanded(
          flex: row1height,
          child: Container(
            color: isDebugging ? Colors.amber : Colors.transparent,
          ),
        ),

        // Row 2: Clock
        Expanded(
          flex: row2height,
          child: Row(
            children: [
              // far left space row2Column1
              Expanded(
                flex: row2Column1width,
                child: Container(
                  color: isDebugging ? Colors.blue : Colors.transparent,
                ),
              ),
              // Space between AM/PM and clock
              Expanded(
                flex: row2Column2width, // 14.04% of the row's width
                child: Container(
                  color: isDebugging ? Colors.greenAccent : Colors.transparent,
                  alignment: isLandscape
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    height: amPmHeight,
                    color:
                        isDebugging ? Colors.indigoAccent : Colors.transparent,
                    child: SizedBox(
                      height: amPmHeight,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          children: [
                            // AM Text
                            Text(
                              clockService.amPm == '' ? '' : 'AM',
                              style: TextStyle(
                                fontSize: amPmFontSize,
                                fontWeight: FontWeight.w600,
                                backgroundColor: isDebugging
                                    ? Colors.yellow
                                    : Colors.transparent,
                                color: clockService.amPm == 'PM'
                                    ? Color(0xFF8F8F8F)
                                    : Color(0xFF2F2F2F),
                              ),
                            ),
                            // Responsive Space
                            SizedBox(
                                height: amPmFontSize *
                                    1.3), // Adjust proportionally
                            // PM Text
                            Text(
                              clockService.amPm == '' ? '' : 'PM',
                              style: TextStyle(
                                fontSize: amPmFontSize,
                                fontWeight: FontWeight.w600,
                                backgroundColor: isDebugging
                                    ? Colors.yellow
                                    : Colors.transparent,
                                color: clockService.amPm == 'AM'
                                    ? Color(0xFF8F8F8F)
                                    : Color(0xFF2F2F2F),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Time Text
              Expanded(
                flex: row2Column3width,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double availableWidth =
                        constraints.maxWidth; // Get the parent width
                    double availableHeight = constraints.maxHeight;
                    return Container(
                      color:
                          isDebugging ? Colors.pinkAccent : Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Hours
                          Container(
                            color: isDebugging
                                ? Colors.yellow
                                : Colors.transparent,
                            width: availableWidth * 0.44,
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                clockService.hours,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2F2F2F),
                                  height: 1.0,
                                  letterSpacing: isLandscape ? -1 : -3,
                                ),
                              ),
                            ),
                          ),

                          // Colon
                          Column(
                            children: [
                              Container(
                                color: isDebugging
                                    ? Colors.deepOrange
                                    : Colors.transparent,
                                width: isLandscape
                                    ? availableWidth * 0.12
                                    : availableWidth * 0.08,
                                height: availableHeight,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    clockService.isColonVisible ? ':' : ' ',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF2F2F2F),
                                        letterSpacing: isLandscape ? 1 : -3,
                                        height: 0.9),
                                    textHeightBehavior:
                                        const TextHeightBehavior(
                                      applyHeightToFirstAscent: true,
                                      applyHeightToLastDescent: false,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Minutes
                          Container(
                            color: isDebugging
                                ? Colors.orange
                                : Colors.transparent,
                            width: availableWidth * 0.44,
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                clockService.minutes,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2F2F2F),
                                  height: 1.0,
                                  letterSpacing: isLandscape ? -1 : -3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: row2Column4width,
                child: Container(
                  color: isDebugging ? Colors.tealAccent : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
        // Date Text
        Expanded(
          flex: dateHeight,
          child: Container(
            color: isDebugging ? Colors.brown : Colors.transparent,
            alignment: Alignment.center,
            child: clockService.isDateSelected
                ? Text(
                    clockService.date,
                    style: TextStyle(
                      fontSize: dateFontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                : null,
          ),
        ),
        Expanded(
          flex: row3Height, // 15.47% of the parent's height
          child: Container(
            color: isDebugging ? Colors.red : Colors.transparent,
          ),
        ),
      ],
    );
  }
}
