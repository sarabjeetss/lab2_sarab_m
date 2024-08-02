// lib/calculator_state.dart

import 'package:shared_preferences/shared_preferences.dart';

class CalculatorState {
  static const _lastValueKey = 'lastValue';

  Future<void> saveLastValue(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastValueKey, value);
  }

  Future<String> loadLastValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastValueKey) ?? '';
  }
}
