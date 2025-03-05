import 'package:flutter/material.dart';
import 'game_page.dart'; // Ensure GamePage is properly imported

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedMode = 'Easy'; // Default difficulty

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Memorix'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 320,
                  child: SegmentedButton<String>(
                    segments: [
                      ButtonSegment(value: 'Easy', label: Text('Easy', style: TextStyle(color: colorScheme.onSurface))),
                      ButtonSegment(value: 'Medium', label: Text('Medium', style: TextStyle(color: colorScheme.onSurface))),
                      ButtonSegment(value: 'Hard', label: Text('Hard', style: TextStyle(color: colorScheme.onSurface))),
                    ],
                    selected: {_selectedMode},
                    onSelectionChanged: (newSelection) {
                      setState(() => _selectedMode = newSelection.first);
                    },
                    style: SegmentedButton.styleFrom(
                      side: BorderSide(color: colorScheme.outline, width: 1),
                      backgroundColor: colorScheme.surface,
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Reduced spacing
                OutlinedButton(
                  onPressed: () {
                    // Navigate to GamePage with the selected difficulty
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GamePage(difficulty: _selectedMode),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 20),
                    side: BorderSide(color: colorScheme.outline, width: 1),
                    foregroundColor: colorScheme.onSurface,
                  ),
                  child: const Text('Play'),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 50, // 56dp from the bottom
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton.extended(
                onPressed: () {
                  print("Infinity Mode Activated");
                },
                label: const Text('Infinity'),
                icon: const Icon(Icons.all_inclusive),
                backgroundColor: colorScheme.surfaceVariant, // Light color
                foregroundColor: colorScheme.onSurface, // Adaptive text/icon color
              ),
            ),
          ),
        ],
      ),
      backgroundColor: colorScheme.background,
    );
  }
}