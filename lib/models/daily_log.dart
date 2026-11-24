import 'package:flutter/material.dart';

class DailyLog {
  final DateTime date;
  final IconData icon;
  final int waterGlasses;
  final double sleepHours;
  final bool isNoSugar;
  final bool didExercise;

  const DailyLog(
    this.date,
    this.icon,
    this.waterGlasses,
    this.sleepHours,
    this.isNoSugar,
    this.didExercise,
  );
}
