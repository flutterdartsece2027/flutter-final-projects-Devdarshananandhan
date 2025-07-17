import 'package:flutter/material.dart';

class GlobalState {
  static int userId = 0;
  static ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);
  static int selectedindex = 0;
}
