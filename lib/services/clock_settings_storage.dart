import 'package:shared_preferences/shared_preferences.dart';

class ClockSettingsStorage {
  static const String _keySelectedScreenIndex = "";

  /// Save the selected screen index
  static Future<void> saveSelectedScreenIndex(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keySelectedScreenIndex, index);
      // print("Saved selected screen index: $index");
    } catch (e) {
      print("Error saving selected screen index: $e");
    }
  }

  /// Load the selected screen index
  static Future<int> loadSelectedScreenIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final index = prefs.getInt(_keySelectedScreenIndex) ?? 0;
      print("Loaded selected screen index: $index");
      return index;
    } catch (e) {
      print("Error loading selected screen index: $e");
      return 0; // Fallback to default screen index
    }
  }

  /// Save the selected button state
  static Future<void> saveSelectedButtons(
      Map<String, bool> selectedButtons) async {
    final prefs = await SharedPreferences.getInstance();
    for (var key in selectedButtons.keys) {
      await prefs.setBool(key, selectedButtons[key]!);
      // print('Saved $key: ${selectedButtons[key]}');
    }
  }

  /// Load the selected button state
  static Future<Map<String, bool>> loadSelectedButtons() async {
    final prefs = await SharedPreferences.getInstance();

    // Default settings
    Map<String, bool> defaultSettings = {
      'ANALOG': false,
      '12h': true, // Default: 12h mode
      'BASIC': true, // Default: Basic clock style
      'DATE': true, // Default: Date is shown
      'DIGITAL': true, // Default: Digital clock style
      '24h': false,
      'FLIP': false,
      'CALENDAR': false,
      'WORLD CLOCK': false,
      'STOPWATCH': false,
      'TIMER': false,
    };

    // Load stored preferences, if available
    for (var key in defaultSettings.keys) {
      defaultSettings[key] = prefs.getBool(key) ?? defaultSettings[key]!;
    }

    return defaultSettings;
  }
}
