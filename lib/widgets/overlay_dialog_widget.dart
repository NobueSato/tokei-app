import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../services/clock_service.dart';
import '../services/clock_settings_storage.dart';

class OverlayDialogWidget extends StatefulWidget {
  final int indexNum;
  final Function(int) onButtonPressed; // Callback function to pass data
  final bool is12h24hdisabled = false;
  final bool isClockTypedisabled = false;
  const OverlayDialogWidget({
    super.key,
    required this.indexNum,
    required this.onButtonPressed, // Accept the callback
  });

  @override
  _OverlayDialogWidgetState createState() => _OverlayDialogWidgetState();
}

class _OverlayDialogWidgetState extends State<OverlayDialogWidget> {
  int _selectedScreen = 0;
  late ClockService clockService;

  Map<String, bool> selectedButtons = {
    'ANALOG': false,
    '12h': true, // Default to 12h mode when the app starts
    'BASIC': true, // Default to basic clock style when the app starts
    'DATE': true, // Default to show date when the app starts
    'DIGITAL': true, // Default to digital clock style when the app starts
    '24h': false,
    'FLIP': false,
    'CALENDAR': false,
    'WORLD CLOCK': false,
    'STOPWATCH': false,
    'TIMER': false,
  };

  @override
  void initState() {
    super.initState();
    clockService = Provider.of<ClockService>(context, listen: false);
    _loadSelectedButtons();
    _loadSelectedScreen();
    print(
        '*** overlay init when its loaded $selectedButtons and $_selectedScreen ***');
  }

  Future<void> _loadSelectedButtons() async {
    ClockSettingsStorage.loadSelectedButtons().then((loadedButtons) {
      setState(() {
        selectedButtons = loadedButtons; // Update the selected buttons
        print('loaded buttons: $loadedButtons');
      });
    });
  }

  Future<void> _loadSelectedScreen() async {
    ClockSettingsStorage.loadSelectedScreenIndex().then((index) {
      setState(() {
        _selectedScreen = index; // Update the selected buttons
        print(_selectedScreen);
      });
    });
  }

  /// Checks if any view mode button is selected
  bool isAnyViewModeSelected() {
    return selectedButtons.entries.any((entry) =>
        ['BASIC', 'CALENDAR', 'WORLD CLOCK', 'STOPWATCH', 'TIMER']
            .contains(entry.key) &&
        entry.value);
  }

  // Checks if the flip mode button is selected
  bool isFlipModeSelected() {
    return selectedButtons.entries
        .any((entry) => ['FLIP'].contains(entry.key) && entry.value);
  }

// Checks if the analog button is selected
  bool isAnalogSelected() {
    return selectedButtons.entries
        .any((entry) => ['ANALOG'].contains(entry.key) && entry.value);
  }

// Diselect Analog button.
  void disableAnalogButton() {
    setState(() {
      selectedButtons['ANALOG'] = false;
      clockService.toggleAnalogClock(toggle: 0);
    });
  }

  // Check if any clock type button is selected
  bool isClockTypeSelected() {
    if (selectedButtons['ANALOG'] == true ||
        selectedButtons['DIGITAL'] == true) {
      return true;
    } else {
      return false;
    }
  }

  // Update all the view mode buttons. Make sure to deselect all the buttons except the selected one
  void updateButtons(String selectedKey) {
    setState(() {
      final Set<String> viewModeButtons = {
        'BASIC',
        'CALENDAR',
        'WORLD CLOCK',
        'STOPWATCH',
        'TIMER'
      };

      // Iterate through only the relevant buttons and update their values
      for (String key in viewModeButtons) {
        selectedButtons[key] = (key == selectedKey);
      }
    });
  }

  Future<void> toggleSelection(String button) async {
    print('Toggling button: $button | Current selection: $selectedButtons');
    // Categories for different button types
    final Set<String> clockTypeButtons = {'ANALOG', 'DIGITAL'};
    final Set<String> timeModeButtons = {'12h', '24h'};
    final Set<String> dateButton = {'DATE'};
    final Set<String> viewModeButtons = {
      'BASIC',
      'CALENDAR',
      'WORLD CLOCK',
      'STOPWATCH',
      'TIMER'
    };
    final Set<String> flipModeButton = {'FLIP'};
    setState(() {
      // If the button is clock type: ANALOG or DIGITAL
      if (clockTypeButtons.contains(button)) {
        // Handle clock type(Analog or Digital) button logic
        // Check if the button is either ANALOG or DIGITAL
        if (selectedButtons[button] == false) {
          // If the button is not selected, deselect the other button
          selectedButtons[button] = true; // Select the button
          selectedButtons[button == 'ANALOG' ? 'DIGITAL' : 'ANALOG'] =
              false; // Deselect the other button
          clockService.toggleAnalogClock(); // Toggle the clock type
          print(
              'clock type button selected: $selectedButtons | {$clockService.isAnalogSelected}');
          if (selectedButtons['ANALOG'] ?? false) {
            // If the analog button is selected
            // Deselect the clock style buttons
            selectedButtons['12h'] = false;
            selectedButtons['24h'] = false;
            print(
                'ANALOG type button selected: $selectedButtons | {$clockService.isAnalogSelected}');
            if (selectedButtons['FLIP'] ?? false) {
              // Deselect the flip mode button
              selectedButtons['FLIP'] = false;
              clockService.toggleFlipClock();
              print(
                  'FLIP type button selected: $selectedButtons | {$clockService.isAnalogSelected} isFlip? {$clockService.isFlipSelected}');
            }
          }
          if (selectedButtons['DIGITAL'] ?? false) {
            print(
                'DIGITAL type button selected: $selectedButtons | {$clockService.isAnalogSelected}');
            // Deselect the clock style buttons
            if (clockService.is24hSelected) {
              selectedButtons['12h'] = false;
              selectedButtons['24h'] = true;
              clockService.toggleTimeFormat(toggle: 1);
              print(
                  'is24hSelected in clock service: ${clockService.is24hSelected}');
              print(selectedButtons);
            } else {
              selectedButtons['12h'] = true;
              selectedButtons['24h'] = false;
              clockService.toggleTimeFormat(toggle: 2);
              print(
                  '24h isnt selected in clock service: ${clockService.is24hSelected}');
              print(selectedButtons);
            }
          }
          if (_selectedScreen > 0) {
            clockService.setSmallScreen(true);
          }
        } // If the button is already selected, do nothing
      } else if (timeModeButtons.contains(button)) {
        // Check if the button is either 12h or 24h
        print("Time Mode button selected: $button");
        // Handle 12h/24h mode logic
        if (clockService.isAnalogSelected) {
          // If the Analog button is selected, do nothing
          return;
        } else {
          // Digital clock style
          // If the button is not selected, deselect the other button
          selectedButtons[button] = true;
          selectedButtons[button == '12h' ? '24h' : '12h'] = false;
          clockService.toggleTimeFormat();
        }
      } else if (dateButton.contains(button)) {
        // Check if the button is DATE
        print("Date button selected: $button");
        // Handle date button logic
        selectedButtons[button] = !selectedButtons[button]!;
        clockService.toggleDate();
      } else if (viewModeButtons.contains(button)) {
        // Check if the button is any of the view mode buttons: BASIC, CALENDAR, WORLD CLOCK, STOPWATCH, TIMER
        print("View Mode button selected: $button");
        // Handle view mode button logic
        // Update the selected screen index based on the button pressed
        if (selectedButtons[button] == false) {
          updateButtons(
              button); // Deselect all view mode buttons except the selected one
          switch (button) {
            case 'BASIC':
              _selectedScreen = 0;
              clockService.setSmallScreen(false);
              break;
            case 'CALENDAR':
              _selectedScreen = 1;
              clockService.setSmallScreen(true);
              break;
            case 'WORLD CLOCK':
              _selectedScreen = 2;
              clockService.setSmallScreen(true);
              break;
            case 'STOPWATCH':
              _selectedScreen = 3;
              clockService.setSmallScreen(true);
              break;
            case 'TIMER':
              _selectedScreen = 4;
              clockService.setSmallScreen(true); // Confirm if this is correct
              break;
            default:
              break;
          }
          if (!isClockTypeSelected()) {
            // If no clock type button is selected, select the digital clock type
            selectedButtons['DIGITAL'] = clockService.is24hSelected
                ? false
                : true; // Select the digital clock type
            selectedButtons['12h'] = clockService.is24hSelected
                ? false
                : true; // Select the 12h time mode
          }
        }
      } else if (flipModeButton.contains(button)) {
        print("Flip Mode button selected: $button");
        // Handle FLIP mode button logic
        if (!clockService.isAnalogSelected) {
          if (selectedButtons['DIGITAL'] == true &&
              selectedButtons['FLIP'] == false) {
            // Flip button cannot be toggle on/off by clicking on it
            disableAnalogButton(); // Deselect ANALOG
            clockService.toggleFlipClock();
            print('when the flip button is selected $selectedButtons');
            selectedButtons['FLIP'] = true;
          } else {
            // If the flip button is already selected, deselect it
            selectedButtons['FLIP'] = false;
            clockService.toggleFlipClock();
            print('when the flip button is deselected $selectedButtons');
          }
        }
      }
    });
    await ClockSettingsStorage.saveSelectedButtons(selectedButtons);
    print('saved selected buttons: $selectedButtons');
    await ClockSettingsStorage.saveSelectedScreenIndex(_selectedScreen);
    // print('saved screen index: $_selectedScreen');
    // Pass the selected button value back using the callback
    widget.onButtonPressed(_selectedScreen); // Trigger the callback
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isLandscape = screenWidth > screenHeight;

    List<String> modeList = [
      'ANALOG',
      '12h',
      'DATE',
      'DIGITAL',
      '24h',
      'FLIP',
      '',
      'BASIC',
      'CALENDAR',
      'WORLD CLOCK',
      'STOPWATCH',
      'TIMER'
    ];

    return Dialog.fullscreen(
      backgroundColor: const Color.fromARGB(229, 211, 213, 224),
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
              child: Container(color: Colors.transparent),
            ),
          ),
          // Close button
          Positioned(
            top: 50,
            right: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(50, 50),
                backgroundColor: const Color.fromARGB(180, 255, 255, 255),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Icon(Icons.close, color: Color(0xFF2F2F2F), size: 24),
            ),
          ),
          Center(
            child: isLandscape
                ? _buildLandscapeLayout(modeList)
                : _buildPortraitLayout(modeList),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildColumn(buttons.sublist(0, 3), 130),
        SizedBox(width: 11),
        _buildColumn(buttons.sublist(3, 6), 130),
        SizedBox(width: 11),
        SizedBox(width: 130),
        SizedBox(width: 11),
        _buildColumn(buttons.sublist(7, 12), 164),
      ],
    );
  }

  Widget _buildPortraitLayout(List<String> buttons) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildColumn(buttons.sublist(0, 3), 97.5),
            SizedBox(width: 9),
            _buildColumn(buttons.sublist(3, 6), 97.5),
          ],
        ),
        SizedBox(height: 26),
        _buildColumn(buttons.sublist(7, 12), 204),
      ],
    );
  }

  Widget _buildColumn(List<String> buttons, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: buttons.map((text) {
        if (text.isEmpty) return SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ElevatedButton(
              onPressed: () => toggleSelection(text),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedButtons[text]!
                    ? const Color.fromARGB(185, 188, 188, 205)
                    : const Color.fromARGB(180, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fixedSize: Size(width, 40),
                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 11.9),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: FittedBox(
                child: Text(text,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
