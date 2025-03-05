import 'package:flutter/material.dart';

// Light Theme Colors
const Color primaryLight = Color(0xFF3B82F6); // Blue
const Color onPrimaryLight = Colors.white;
const Color backgroundLight = Color(0xFFF5F5F5);
const Color surfaceLight = Colors.white;
const Color outlineLight = Color(0xFF79747E);

// Dark Theme Colors
const Color primaryDark = Color(0xFF90CAF9); // Lighter blue for contrast
const Color onPrimaryDark = Colors.black;
const Color backgroundDark = Color(0xFF121212);
const Color surfaceDark = Color(0xFF1E1E1E);
const Color outlineDark = Color(0xFFBDBDBD);

// Define ColorSchemes
final ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: primaryLight,
  onPrimary: onPrimaryLight,
  background: backgroundLight,
  surface: surfaceLight,
  onSurface: Colors.black,
  outline: outlineLight,
  secondary: Color(0xFF4CAF50), // Green
  onSecondary: Colors.white,
  error: Color(0xFFB00020), // Red
  onError: Colors.white,
);

final ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: primaryDark,
  onPrimary: onPrimaryDark,
  background: backgroundDark,
  surface: surfaceDark,
  onSurface: Colors.white,
  outline: outlineDark,
  secondary: Color(0xFF81C784), // Light green
  onSecondary: Colors.black,
  error: Color(0xFFCF6679), // Lighter red for dark mode
  onError: Colors.black,
);