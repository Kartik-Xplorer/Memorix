import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // To open the GitHub link

class SettingsPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;

  SettingsPage({required this.toggleTheme, required this.themeMode});

  // Function to open the GitHub link
  Future<void> _launchURL() async {
    const url = 'https://github.com/your-repo'; // Replace with your GitHub repository link
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // "Developed by Kartik-Xplorer" text with sprinklers
              Text(
                'Developed by Kartik-Xplorer✨',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 20),
              // About Material UI
              Text(
                'Memorix!',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              SizedBox(height: 20),
              // Light/Dark theme toggle
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
              SizedBox(height: 40),
              // Source code button with Material UI OutlinedButton
              OutlinedButton(
                onPressed: _launchURL,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blueAccent, side: BorderSide(color: Colors.blueAccent, width: 2),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.code, color: Colors.blueAccent),
                    SizedBox(width: 8),
                    Text(
                      'Source Code',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '<>',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}