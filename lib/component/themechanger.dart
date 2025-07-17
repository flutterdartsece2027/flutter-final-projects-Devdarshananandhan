import 'package:flutter/material.dart';
import 'package:notevault/global/globalstate.dart';

class Themechanger extends StatefulWidget {
  const Themechanger({super.key});

  @override
  State<Themechanger> createState() => _ThemechangerState();
}

class _ThemechangerState extends State<Themechanger> {
  @override
  Widget build(BuildContext context) {
    bool isDark = GlobalState.themeNotifier.value == ThemeMode.dark;

    return AlertDialog(
      title: const Text("Change Theme"),
      content: Row(
        children: [
          const Text("Dark Mode"),
          const Spacer(),
          Switch(
            value: isDark,
            onChanged: (value) {
              GlobalState.themeNotifier.value =
                  value ? ThemeMode.dark : ThemeMode.light;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        )
      ],
    );
  }
}
