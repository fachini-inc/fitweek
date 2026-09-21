import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const FitWeekApp());
}

class FitWeekApp extends StatelessWidget {
  const FitWeekApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitWeek',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const HomeScreen(),
    );
  }
}
