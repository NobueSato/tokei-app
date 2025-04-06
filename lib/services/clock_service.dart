import 'dart:async'; // Add this import for Timer
import 'package:flutter/material.dart';
import '../services/clock_settings_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClockService extends ChangeNotifier {
  Timer? _timer;
  String _hours = '';
  String _minutes = '';
  String _date = '';
  String _amPm = ''; // Add a property to store AM/PM information
  bool get isColonVisible =>
      DateTime.now().second % 2 == 0; // Blink every second
  bool _is12hSelected = true; // Default to 12H format
  bool _is24hSelected = false;
  bool _isDateSelected = false;
  bool _isFlipSelected = false;
  bool _isAnalogSelected = false;
  int _clockModeNum = 0; // Default to basic clock mode

  // Getters for the properties
  String get hours => _hours;
  String get minutes => _minutes;
  String get date => _date;
  String get amPm => _amPm; // Getter for AM/PM
  bool get is12hSelected => _is12hSelected;
  bool get is24hSelected => _is24hSelected;
  bool get isDateSelected => _isDateSelected;
  bool get isFlipSelected => _isFlipSelected;
  bool get isAnalogSelected => _isAnalogSelected;
  int get clockModeNum => _clockModeNum;

  ClockService() {
    _updateTime();
    _startTimer(); // Start the timer to update time every second
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    Map<String, bool> buttons =
        await ClockSettingsStorage.loadSelectedButtons();
    _is12hSelected = buttons['12h'] ?? true;
    _is24hSelected = buttons['24h'] ?? false;
    _isDateSelected = buttons['DATE'] ?? false;
    _isFlipSelected = buttons['FLIP'] ?? false;
    _isAnalogSelected = buttons['ANALOG'] ?? false;
    setClockMode();
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDateSelected', _isDateSelected);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTime();
    });
  }

  // Method to toggle between 12h and 24h format
  void toggleTimeFormat({int toggle = 0}) {
    // if off is 0, toggle, if 1, turn off 12h, if 2, turn off 24h
    if (toggle == 0) {
      _is12hSelected = !_is12hSelected;
      _is24hSelected = !_is24hSelected;
    } else if (toggle == 1) {
      _is12hSelected = false;
      _is24hSelected = true;
    } else {
      _is12hSelected = true;
      _is24hSelected = false;
    }
    _updateTime(); // Update time immediately after format change
  }

  void toggleDate() {
    _isDateSelected = !_isDateSelected;
    _savePreferences();
    notifyListeners();
  }

  void toggleFlipClock() {
    _isFlipSelected = !_isFlipSelected;
    setClockMode();
    notifyListeners();
  }

  void toggleAnalogClock({int toggle = 1}) {
    // if off is 1, toggle, if 0, turn off
    if (toggle == 1) {
      _isAnalogSelected = !_isAnalogSelected;
    } else {
      _isAnalogSelected = false;
    }
    setClockMode();
    print('Analog: $_isAnalogSelected');
    notifyListeners();
  }

  void setClockMode() {
    if (isAnalogSelected) {
      _clockModeNum = 1; // Analog clock mode
    } else if (isFlipSelected) {
      _clockModeNum = 2; // Flip clock mode
    } else {
      _clockModeNum = 0; // Basic clock mode
    }
    print('Clock mode: $_clockModeNum');
    notifyListeners();
  }

  // Update time based on the selected format
  void _updateTime() {
    final now = DateTime.now();

    if (_is12hSelected) {
      _hours = _formatTime(now.hour); // Convert to 12-hour format
      _amPm = _getAmPm(now.hour); // Set AM/PM for 12-hour format
    } else {
      _hours = now.hour.toString().padLeft(2, '0'); // 24-hour format
      _amPm = ''; // No AM/PM needed for 24-hour format
    }

    _minutes = now.minute.toString().padLeft(2, '0');
    _date = _getFormattedDate(); // Get formatted date

    // Notifies UI to update
    notifyListeners();
  }

  // Helper function to format time for 12-hour format
  String _formatTime(int hour) {
    return hour % 12 == 0 ? '12' : (hour % 12).toString().padLeft(2, '0');
  }

  // Helper function to get AM or PM based on the hour
  String _getAmPm(int hour) {
    return hour < 12 ? 'AM' : 'PM';
  }

  // Helper function to get the formatted date
  String _getFormattedDate() {
    final DateTime now = DateTime.now();
    final weekday = [
      'MONDAY',
      'TUESDAY',
      'WEDNESDAY',
      'THURSDAY',
      'FRIDAY',
      'SATURDAY',
      'SUNDAY'
    ][now.weekday - 1];
    return '${now.year} - ${now.month.toString().padLeft(2, '0')} - ${now.day.toString().padLeft(2, '0')} $weekday';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
