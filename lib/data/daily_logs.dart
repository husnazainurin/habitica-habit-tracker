import 'package:habitica_habit_tracker/models/daily_log.dart';

final List<DailyLog> sampleDailyLogs = [
  // Wednesday (Exercise Day)
  DailyLog(DateTime(2026, 11, 25), 8, 8.0, true, false, false),

  // Tuesday
  DailyLog(DateTime(2026, 11, 24), 7, 7.5, true, false, true),

  // Monday (Exercise Day)
  DailyLog(DateTime(2026, 11, 23), 7, 8.0, true, true, true),

  // Cheat Day (Sunday)
  DailyLog(DateTime(2026, 11, 22), 3, 10.5, false, false, true),

  // Saturday
  DailyLog(DateTime(2026, 11, 21), 3, 9.0, false, false, false),
];
