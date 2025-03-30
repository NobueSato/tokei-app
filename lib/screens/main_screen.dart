import 'package:flutter/material.dart';
import '../screens/calendar_screen.dart';
import '../screens/clock_screen.dart';
import '../screens/stopwatch_screen.dart';
import '../screens/timer_screen.dart';
import '../screens/world_clock_screen.dart';
import '../widgets/floating_buttons_widget.dart';
import '../widgets/overlay_dialog_widget.dart';
import '../services/clock_settings_storage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ClockScreen(), // 0
    const CalendarScreen(), // 1
    const WorldClockScreen(), // 2
    const StopwatchScreen(), // 3
    const TimerScreen(), // 4
  ];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    print('*** main_screen init state ***');
  }

  Future<void> _loadPreferences() async {
    int index = await ClockSettingsStorage.loadSelectedScreenIndex();
    setState(() {
      _currentIndex = index;
    });
  }

  void _showOverlay(int buttonIndex) {
    // index is the selected button index 0 = mode, 1 = wow, 2 = settings
    showDialog(
      context: context,
      builder: (context) => OverlayDialogWidget(
        indexNum: buttonIndex, // Pass the selected Floating action button index
        onButtonPressed: (selectedScreen) {
          // Callback function to update the screen index
          setState(() {
            _currentIndex = selectedScreen;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content screen inside FloatingButtonsWidget
          FloatingButtonsWidget(
            onButtonPressed:
                _showOverlay, // Send the callback to the FloatingButtonsWidget
            child: _screens[
                _currentIndex], // Display the current screen based on index
          )
        ],
      ),
    );
  }
}
