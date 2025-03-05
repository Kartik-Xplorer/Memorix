import 'package:flutter/material.dart';

class MyNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  MyNavigationBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Define colors with proper contrast
    final Color backgroundColor = colorScheme.surface;
    final Color selectedColor = colorScheme.primary;
    final Color unselectedColor = colorScheme.onSurface.withOpacity(0.6);
    final Color labelColor = colorScheme.onSurface; // Ensures text is visible

    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: backgroundColor,
        indicatorColor: selectedColor.withOpacity(0.2), // Subtle highlight
        labelTextStyle: MaterialStateProperty.all(
          TextStyle(color: labelColor), // Ensures text is visible
        ),
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onItemTapped,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.sports_esports,
                color: selectedIndex == 0 ? selectedColor : unselectedColor),
            label: 'Play',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart,
                color: selectedIndex == 1 ? selectedColor : unselectedColor),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings,
                color: selectedIndex == 2 ? selectedColor : unselectedColor),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}