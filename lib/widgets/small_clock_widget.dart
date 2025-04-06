import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/clock_service.dart';

class SmallClockWidget extends StatelessWidget {
  final double fontSize;
  final double dateFontSize;
  final double amPmFontSize;
  final bool is12hSelected = true;
  final bool is24hSelected = false;
  final bool isDateSelected = false;

  const SmallClockWidget({
    Key? key,
    required this.fontSize,
    required this.dateFontSize,
    required this.amPmFontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clockService = Provider.of<ClockService>(context);
    bool isDebugging = true;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    // Get the screen height using MediaQuery
    double screenHeight = MediaQuery.of(context).size.height;

    int row1height = isLandscape
        ? 3100 // 23.46% when it's landscape
        : 0; // 43.10% when it's portrait
    int row2height = isLandscape
        ? 3500 // 4200% when it's landscape
        : 8600; // 13.8% when it's portrait
    int row3Height = isLandscape
        ? 0800 // 9% when it's landscape
        : 1400; // 43.1% when it's portrait
    int row4Height = isLandscape
        ? 2600 // 13.76% when it's landscape
        : 0; // 43.1% when it's portrait
    int row2Column1width = isLandscape
        ? 0800 // 8% when it's landscape
        : 0640; // 6.4% when it's portrait
    int row2Column2width = isLandscape
        ? 1000 // 10% when it's landscape
        : 1146; // 11.46% when it's portrait
    int row2Column3width = isLandscape
        ? 7300 // 73% when it's landscape
        : 5707; // 57.07% when it's portrait
    int row2Column4width = isLandscape
        ? 0900 // 10% when it's landscape
        : 1506; // 21.06% when it's portrait
    double amPmHeight = isLandscape
        ? screenHeight * 0.2453 // 24.53 when it's landscape
        : screenHeight * 0.0738; // 7.38% when it's portrait

    return Column(
      children: [
        // Row 1: Space above the clock
        Expanded(
          flex: row1height,
          child:
              Container(color: isDebugging ? Colors.pink : Colors.transparent),
        ),

        // Row 2: Clock
        Expanded(
          flex: row2height,
          child: Row(
            children: [
              // Row 2 Column1: far left space
              Flexible(
                flex: row2Column1width,
                child: Container(
                    color: isDebugging ? Colors.amber : Colors.transparent),
              ),
              // Row 2 Column2: Space between AM/PM and clock
              Expanded(
                flex: row2Column2width, // 14.04% of the row's width
                child: Container(
                  color: isDebugging ? Colors.blue : Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: isLandscape
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          height: amPmHeight,
                          // color: Colors.purple,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, // Space in between
                                children: [
                                  // AM Text
                                  Text(
                                    clockService.amPm == '' ? '' : 'AM',
                                    style: TextStyle(
                                      fontSize: amPmFontSize,
                                      fontWeight: FontWeight.w600,
                                      color: clockService.amPm == 'PM'
                                          ? Color(0xFF8F8F8F)
                                          : Color(0xFF2F2F2F),
                                    ),
                                  ),
                                  // PM Text
                                  Text(
                                    clockService.amPm == '' ? '' : 'PM',
                                    style: TextStyle(
                                      fontSize: amPmFontSize,
                                      fontWeight: FontWeight.w600,
                                      color: clockService.amPm == 'AM'
                                          ? Color(0xFF8F8F8F)
                                          : Color(0xFF2F2F2F),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Row 2 Column3: Time Text
              Expanded(
                flex: row2Column3width,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double availableWidth =
                        constraints.maxWidth; // Get the parent width
                    double availableHeight = constraints.maxHeight;
                    return Container(
                      color: isDebugging
                          ? const Color.fromARGB(255, 200, 173, 246)
                          : Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Hours
                          Container(
                            color: isDebugging
                                ? const Color.fromARGB(255, 182, 245, 215)
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
                                  height: 1.0,
                                  letterSpacing: isLandscape ? -1 : -3,
                                ),
                              ),
                            ),
                          ),

                          // Colon
                          Column(
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Container(
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
                              ),
                            ],
                          ),
                          // Minutes
                          Container(
                            color:
                                isDebugging ? Colors.blue : Colors.transparent,
                            width: availableWidth * 0.44,
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                clockService.minutes,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w700,
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
                    color: isDebugging
                        ? Colors.deepPurpleAccent
                        : Colors.transparent),
              ),
            ],
          ),
        ),
        // Date Text
        Expanded(
          flex: row3Height,
          child: Container(
            color: isDebugging ? Colors.brown : Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: isDebugging ? Colors.amber : Colors.transparent,
                  child: Align(
                    alignment: Alignment.centerLeft, // Align text to the left
                    child: clockService.isDateSelected
                        ? Text(
                            clockService.date,
                            textAlign:
                                TextAlign.left, // Ensure text is left-aligned
                            style: TextStyle(
                              fontSize: dateFontSize,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Row 4
        Expanded(
          flex: row4Height, // 15.47% of the parent's height
          child: Container(
              color:
                  isDebugging ? Colors.lightGreenAccent : Colors.transparent),
        ),
      ],
    );
  }
}
