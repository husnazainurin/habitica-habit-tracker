import 'package:flutter/material.dart';
import 'package:habitica_habit_tracker/data/goals.dart';
import 'package:habitica_habit_tracker/models/daily_log.dart';
import 'package:habitica_habit_tracker/models/goal.dart';
import 'package:intl/intl.dart';
import 'package:habitica_habit_tracker/data/daily_logs.dart';

class DailyChecklistScreen extends StatefulWidget {
  const DailyChecklistScreen({super.key});

  @override
  State<DailyChecklistScreen> createState() => _DailyChecklistScreen();
}

class _DailyChecklistScreen extends State<DailyChecklistScreen> {
  late List<DailyLog> _dailyLogs;
  late Goal _goal;

  @override
  void initState() {
    super.initState();

    _dailyLogs = List.of(sampleDailyLogs);
    _goal = sampleGoal;
  }

  @override
  Widget build(BuildContext context) {
    final dailyLogs = _dailyLogs;
    final goal = _goal;

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Checklist')),

      body: Column(
        children: [
          // TARGETED GOAL SUMMARY CARD CONTAINER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(20),
            ),

            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [

                      // Title
                      const Icon(Icons.track_changes_rounded),
                      const SizedBox(width: 8),
                      const Text(
                        'Targeted Goal',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Contents
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            
                            // Streak
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDE9FE),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('STREAK PLACEHOLDER'),
                            ),

                            // Targeted Goal
                            DataTable(
                              columns: const [
                                DataColumn(label: Text('Habit')),
                                DataColumn(label: Text('Target')),
                              ],
                              rows: [
                                DataRow(
                                  cells: [
                                    const DataCell(Text('Water Intake')),
                                    DataCell(
                                      Text('${goal.waterTarget} glasses'),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: [
                                    const DataCell(Text('Sleep Hours')),
                                    DataCell(Text('${goal.sleepTarget} hours')),
                                  ],
                                ),
                                DataRow(
                                  cells: [
                                    const DataCell(Text('Exercise Days')),
                                    DataCell(Text('${goal.exerciseDay} days')),
                                  ],
                                ),
                                DataRow(
                                  cells: [
                                    const DataCell(Text('Cheat Days')),
                                    DataCell(Text('${goal.cheatDay} days')),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // DAILY RECORDS SECTION
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Row(
              children: [
                Text(
                  'Daily Records',
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const Spacer(),

                Text(
                  '${dailyLogs.length} days',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          // SCROLLABLE DAILY RECORDS
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              itemCount: dailyLogs.length,

              itemBuilder: (context, index) {
                final log = dailyLogs[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),

                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),

                    leading: CircleAvatar(
                      backgroundColor: log.achieve
                          ? Colors.green.withValues(alpha: 0.12)
                          : Colors.red.withValues(alpha: 0.12),

                      child: Icon(
                        log.achieve
                            ? Icons.check_circle_outline_rounded
                            : Icons.highlight_off,

                        color: log.achieve ? Colors.green : Colors.red,
                      ),
                    ),

                    title: Text(
                      '${DateFormat('EEEE').format(log.date)}, '
                      '${DateFormat('dd/MM').format(log.date)}',
                    ),

                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),

                      child: Row(
                        children: [
                          Icon(
                            Icons.water_drop,
                            size: 20,
                            color: log.waterGlasses >= goal.waterTarget
                                ? Colors.blue
                                : Colors.grey,
                          ),

                          const SizedBox(width: 12),

                          Icon(
                            Icons.bedtime,
                            size: 20,
                            color: log.sleepHours >= goal.sleepTarget
                                ? Colors.purple
                                : Colors.grey,
                          ),

                          const SizedBox(width: 12),

                          Icon(
                            Icons.fitness_center,
                            size: 20,
                            color: log.didExercise ? Colors.green : Colors.grey,
                          ),

                          const SizedBox(width: 12),

                          Icon(
                            log.isNoSugar ? Icons.no_food : Icons.fastfood,
                            size: 20,
                            color: log.isNoSugar ? Colors.orange : Colors.grey,
                          ),
                        ],
                      ),
                    ),

                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${log.date.toString()} tapped'),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
