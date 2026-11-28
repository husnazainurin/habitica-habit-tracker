import 'package:flutter/material.dart';
import 'package:habitica_habit_tracker/screens/daily_checklist_screen.dart';
import 'package:habitica_habit_tracker/screens/goal_add_edit_screen.dart';
import 'package:habitica_habit_tracker/screens/dashboard_screen.dart';
import 'package:habitica_habit_tracker/screens/home.dart';
import 'package:habitica_habit_tracker/shell_screen.dart';
import 'package:habitica_habit_tracker/profile_screen.dart';

void main() {
  runApp(const Habitica());
}

class Habitica extends StatelessWidget {
  const Habitica({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habitica Habit Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const ShellScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/daily_checklist': (context) => const DailyChecklistScreen(),
        '/add_edit': (context) => const GoalAddEditScreen(),
        '/detail': (context) => const DashboardScreen(),
      },
    );
  }
}
