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
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    // Get the screen height using MediaQuery
    double screenHeight = MediaQuery.of(context).size.height;

    // int row1height = isLandscape
    //     ? 2346 // 23.46% when it's landscape
    //     : 4310; // 43.10% when it's portrait
    // int row2height = isLandscape
    //     ? 5334 // 5334% when it's landscape
    //     : 1380; // 13.8% when it's portrait
    // int row3Height = isLandscape
    //     ? 1546 // 15.46% when it's landscape
    //     : 4310; // 43.1% when it's portrait
    // int row2Column1width = isLandscape
    //     ? 0789 // 7.89% when it's landscape
    //     : 0640; // 6.4% when it's portrait
    // int row2Column2width = isLandscape
    //     ? 0615 // 6.15% when it's landscape
    //     : 1146; // 11.46% when it's portrait
    // int row2Column3width = isLandscape
    //     ? 7426 // 74.26% when it's landscape
    //     : 5707; // 57.07% when it's portrait
    // int row2Column4width = isLandscape
    //     ? 1170 // 11.70% when it's landscape
    //     : 2106; // 21.06% when it's portrait
    int dateHeight = isLandscape
        ? 0774 // 12.67% when it's landscape
        : 0246; // 2.46% when it's portrait
    double amPmHeight = isLandscape
        ? screenHeight * 0.2453 // 24.53 when it's landscape
        : screenHeight * 0.0738; // 7.38% when it's portrait

    return Column(
      children: [
        // Row 1: Space above the clock
        Expanded(
          flex: 2,
          child: Container(color: Colors.pink),
        ),

        // Row 2: Clock
        Expanded(
          flex: 6,
          child: Row(
            children: [
              // far left space row2Column1
              Flexible(
                flex: 1,
                child: Container(color: Colors.blue),
              ),
              // Space between AM/PM and clock
              Expanded(
                flex: 1, // 14.04% of the row's width
                child: Container(
                  // color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                  // PM Text
                                  Text(
                                    clockService.amPm == '' ? '' : 'PM',
                                    style: TextStyle(
                                      fontSize: amPmFontSize,
                                      fontWeight: FontWeight.w600,
                                      color: clockService.amPm == 'AM'
                                          ? Colors.grey
                                          : Colors.black,
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
              // Time Text
              Expanded(
                flex: 8,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double availableWidth =
                        constraints.maxWidth; // Get the parent width
                    double availableHeight = constraints.maxHeight;
                    return Container(
                      // color: const Color.fromARGB(255, 200, 173, 246),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Hours
                          Container(
                            // color: const Color.fromARGB(255, 182, 245, 215),
                            width: availableWidth * 0.41,
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                clockService.hours,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w700,
                                  height: 1.0,
                                  letterSpacing: isLandscape ? -1 : -5,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),

                          // Colon
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Container(
                                  width: isLandscape
                                      ? availableWidth * 0.12
                                      : availableWidth * 0.09,
                                  height: availableHeight * 0.95,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      clockService.isColonVisible ? ':' : ' ',
                                      style: TextStyle(
                                          fontSize: fontSize * 0.9,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          letterSpacing: isLandscape ? 1 : -1,
                                          height: 1),
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
                            //color: Colors.blue,
                            width: availableWidth * 0.41,
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                clockService.minutes,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w700,
                                  height: 1.0,
                                  letterSpacing: isLandscape ? -1 : -5,
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
                flex: 1,
                child: Container(color: Colors.transparent),
              ),
            ],
          ),
        ),
        // Date Text
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.brown,
            alignment: Alignment.center,
            child: clockService.isDateSelected
                ? Text(
                    clockService.date,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: dateFontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                : null,
          ),
        ),
        // Expanded(
        //   flex: 1, // 15.47% of the parent's height
        //   child: Container(color: Colors.lightGreenAccent),
        // ),
      ],
    );
  }
}
