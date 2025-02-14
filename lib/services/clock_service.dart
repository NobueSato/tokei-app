import 'dart:async'; // Add this import for Timer

class ClockService {
  Timer? _timer;
  String _hours = '';
  String _minutes = '';
  bool _isColonVisible = true;
  String _date = '';
  String _amPm = ''; // Add a property to store AM/PM information

  Function? onTimeUpdated; // Callback for UI update

  ClockService(is12hSelected) {
    _updateTime(
        is12hSelected); // Update the time immediately when the service is created
    _startTimer(is12hSelected);
  }

  // Getters for the properties
  String get hours => _hours;
  String get minutes => _minutes;
  String get date => _date;
  bool get isColonVisible => _isColonVisible;
  String get amPm => _amPm; // Getter for AM/PM

  void _startTimer(bool is12hSelected) {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTime(is12hSelected);
    });
  }

  void _updateTime(bool is12hSelected) {
    final DateTime now = DateTime.now();
    _isColonVisible = !_isColonVisible;

    if (is12hSelected) {
      _hours = _formatTime(now.hour);
      _minutes = now.minute.toString().padLeft(2, '0');
      _amPm = _getAmPm(now.hour); // Set AM/PM
    } else {
      _hours = now.hour.toString().padLeft(2, '0');
      _minutes = now.minute.toString().padLeft(2, '0');
      _amPm = ''; // No AM/PM in 24-hour format
    }

    // Store formatted date
    _date = _getFormattedDate();

    // Notify UI to update
    onTimeUpdated?.call();
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
    return '${now.year} - ${now.month.toString().padLeft(2, '0')} - ${now.day.toString().padLeft(2, '0')} $weekday';
  }

  void dispose() {
    _timer?.cancel();
  }
}
