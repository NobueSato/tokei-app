import 'dart:async'; // Add this import for Timer

class ClockService {
  Timer? _timer;
  String _hours = '';
  String _minutes = '';
  bool _is24HourFormat = true;
  bool _isColonVisible = true;
  String _date = '';
  String _amPm = ''; // Add a property to store AM/PM information

  // Add a callback for date visibility change
  Function? onDateVisibilityChanged;

  ClockService() {
    _updateTime(); // Update the time immediately when the service is created
    _startTimer();
  }

  // Getters for the properties
  String get hours => _hours;
  String get minutes => _minutes;
  String get date => _date;
  bool get isColonVisible => _isColonVisible;
  bool get is24HourFormat => _is24HourFormat; // Added this getter
  String get amPm => _amPm; // Getter for AM/PM

  // Getter for date visibility (if date is empty, it's not selected)
  bool get isDateSelected => _date.isNotEmpty;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTime();
    });
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    _isColonVisible = !_isColonVisible;

    if (_is24HourFormat) {
      _hours = now.hour.toString().padLeft(2, '0');
      _minutes = now.minute.toString().padLeft(2, '0');
      _amPm = ''; // In 24-hour format, AM/PM is not needed
    } else {
      _hours = _formatTime(now.hour);
      _minutes = now.minute.toString().padLeft(2, '0');
      _amPm = _getAmPm(now.hour); // Set AM/PM based on the current hour
    }
    // Notify listeners for colon visibility change
    onDateVisibilityChanged?.call();
  }

  String _formatTime(int hour) {
    return hour % 12 == 0 ? '12' : (hour % 12).toString().padLeft(2, '0');
  }

  String _getAmPm(int hour) {
    // Return AM or PM based on the hour
    return hour < 12 ? 'AM' : 'PM';
  }

  String _getFormattedDate() {
    final DateTime now = DateTime.now();
    final weekday = [
      'SUNDAY',
      'MONDAY',
      'TUESDAY',
      'WEDNESDAY',
      'THURSDAY',
      'FRIDAY',
      'SATURDAY'
    ][now.weekday - 1];
    return '${now.year} - ${now.month.toString().padLeft(2, '0')} - ${now.day.toString().padLeft(2, '0')} - $weekday';
  }

  void toggleDateView() {
    if (_date.isEmpty) {
      _date = _getFormattedDate();
    } else {
      _date = '';
    }
    // Notify listeners that the date visibility has changed
    onDateVisibilityChanged?.call();
  }

  void toggle24HourFormat() {
    _is24HourFormat = !_is24HourFormat;
    _updateTime();
  }

  void dispose() {
    _timer?.cancel();
  }
}
