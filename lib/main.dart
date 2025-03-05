import 'package:flutter/material.dart';
import 'navbar.dart';
import 'play_page.dart';
import 'stats_page.dart';
import 'settings_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: MainPage(toggleTheme: _toggleTheme, themeMode: _themeMode),
    );
  }
}

class MainPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;

  MainPage({required this.toggleTheme, required this.themeMode});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.fastOutSlowIn,
    );
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            children: [
              HomeScreen(),
              StatsPage(),
              SettingsPage(toggleTheme: widget.toggleTheme, themeMode: widget.themeMode),
            ],
            onPageChanged: (index) => setState(() => _selectedIndex = index),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 70), // Adjust height above navbar
              child: FloatingActionButton.extended(
                onPressed: () {
                  print("Infinity Mode Activated");
                },
                label: const Text('Infinity'),
                icon: const Icon(Icons.all_inclusive),
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant, // Light color
                foregroundColor: Theme.of(context).colorScheme.onSurface, // Adaptive text/icon color
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
                (Set<MaterialState> states) {
              return TextStyle(
                fontWeight: states.contains(MaterialState.selected) ? FontWeight.bold : FontWeight.normal,
                color: states.contains(MaterialState.selected) ? const Color(0xFF21182B) : const Color(0xFF4D4256),
              );
            },
          ),
        ),
        child: MyNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}