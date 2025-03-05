import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;

  SettingsPage({required this.toggleTheme, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '⚙ Settings Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.light_mode, color: Colors.amber),
                Switch(
                  value: themeMode == ThemeMode.dark,
                  onChanged: (value) => toggleTheme(),
                ),
                Icon(Icons.dark_mode, color: Colors.blueGrey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}